class JobPosting < ApplicationRecord
  # "Active" = counts against a poster's cap. Closing a posting frees a slot (per Q4).
  ACTIVE_STATUSES = %w[draft published].freeze
  MAX_ACTIVE_PER_POSTER = 10

  belongs_to :poster, class_name: "User"
  has_many :applications, dependent: :destroy

  enum :employment_type,   { temporary: 0, project_based: 1, full_time_benefits: 2, gig: 3 }
  enum :work_arrangement,  { remote: 0, hybrid: 1, onsite: 2 }
  enum :status,            { draft: 0, published: 1, closed: 2 }
  enum :compensation_period, { hourly: 0, monthly: 1, fixed: 2 }, prefix: :pay

  validates :title, :description, :employment_type, :work_arrangement, :status, presence: true
  validate :within_active_posting_cap, on: :create

  scope :visible, -> { where(status: :published) }
  scope :recent,  -> { order(created_at: :desc) }

  # A blank period from the form means "no period", not an invalid enum value.
  def compensation_period=(value)
    super(value.presence)
  end

  # Enter compensation in dollars; store it in cents.
  def compensation_dollars
    compensation_cents && compensation_cents / 100.0
  end

  def compensation_dollars=(value)
    self.compensation_cents = value.present? ? (value.to_f * 100).round : nil
  end

  def compensation_display
    return "—" if compensation_cents.blank?

    dollars = format("$%.2f", compensation_cents / 100.0)
    suffix =
      case compensation_period
      when "hourly"  then " / hr"
      when "monthly" then " / mo"
      else ""
      end
    "#{dollars}#{suffix}"
  end

  def employment_type_label
    employment_type.to_s.humanize.titleize
  end

  def work_arrangement_label
    work_arrangement.to_s.humanize.titleize
  end

  private

  def within_active_posting_cap
    return if poster.blank?

    active = poster.job_postings.where(status: ACTIVE_STATUSES).where.not(id: id).count
    return if active < MAX_ACTIVE_PER_POSTER

    errors.add(:base, "You can have at most #{MAX_ACTIVE_PER_POSTER} active job postings. Close one to free a slot.")
  end
end
