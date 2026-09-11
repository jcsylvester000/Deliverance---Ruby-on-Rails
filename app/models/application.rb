class Application < ApplicationRecord
  # Terminal stages free a slot (per Q4, active-count cap). Re-applying is allowed after withdraw.
  CLOSED_STAGES = %w[rejected withdrawn].freeze
  MAX_ACTIVE_PER_APPLICANT = 20
  ONBOARDING_STAGES = %w[onboarding hired].freeze

  # Forward pipeline the poster advances through.
  NEXT_STAGE = {
    "applied"      => "under_review",
    "under_review" => "interview",
    "interview"    => "offer",
    "offer"        => "onboarding",
    "onboarding"   => "hired"
  }.freeze

  belongs_to :applicant,   class_name: "User"
  belongs_to :job_posting
  has_one    :interview, dependent: :destroy
  has_many   :onboarding_documents, dependent: :destroy

  enum :stage, {
    applied: 0, under_review: 1, interview: 2, offer: 3,
    onboarding: 4, hired: 5, rejected: 6, withdrawn: 7
  }

  scope :active, -> { where.not(stage: CLOSED_STAGES) }
  scope :recent, -> { order(created_at: :desc) }

  validate  :applicant_must_be_an_applicant
  validate  :job_must_be_open,          on: :create
  validate  :within_active_cap,         on: :create
  validate  :no_active_duplicate,       on: :create

  def closed?
    CLOSED_STAGES.include?(stage)
  end

  def advanceable?
    NEXT_STAGE.key?(stage)
  end

  def onboarding_active?
    ONBOARDING_STAGES.include?(stage)
  end

  # Required onboarding items that still need a file.
  def onboarding_outstanding
    have = onboarding_documents.uploaded.pluck(:kind)
    OnboardingDocument::CHECKLIST.select { |c| c[:required] && !have.include?(c[:kind]) }
  end

  def onboarding_complete?
    onboarding_active? && onboarding_outstanding.empty?
  end

  # Poster moves the application one step forward, notifying the applicant.
  def advance!
    nxt = NEXT_STAGE[stage]
    return false unless nxt

    transaction do
      update!(stage: nxt)
      Notification.create!(user: applicant, kind: :application_advanced, notifiable: self)
    end
    true
  end

  # Poster rejects; applicant is notified.
  def reject!
    transaction do
      update!(stage: :rejected)
      Notification.create!(user: applicant, kind: :application_rejected, notifiable: self)
    end
  end

  # Applicant withdraws; poster is notified.
  def withdraw!
    transaction do
      update!(stage: :withdrawn)
      Notification.create!(user: job_posting.poster, kind: :application_withdrawn, notifiable: self)
    end
  end

  # Called by the controller right after a successful apply.
  def notify_applied!
    Notification.create!(user: job_posting.poster, kind: :application_received, notifiable: self)
  end

  # Ensure the pipeline is at least at the interview stage (used when an interview is scheduled).
  def ensure_at_least_interview!
    update!(stage: :interview) if stage_order(stage) < stage_order("interview")
  end

  def stage_label
    stage.to_s.humanize.titleize
  end

  private

  def stage_order(stage_name)
    %w[applied under_review interview offer onboarding hired].index(stage_name) || -1
  end

  def applicant_must_be_an_applicant
    return if applicant.blank?

    errors.add(:applicant, "must be an applicant account") unless applicant.applicant?
  end

  def job_must_be_open
    return if job_posting.blank?

    errors.add(:base, "This role is no longer accepting applications.") unless job_posting.published?
  end

  def within_active_cap
    return if applicant.blank?

    count = applicant.applications.active.where.not(id: id).count
    return if count < MAX_ACTIVE_PER_APPLICANT

    errors.add(:base, "You can have at most #{MAX_ACTIVE_PER_APPLICANT} active applications. Withdraw one to free a slot.")
  end

  def no_active_duplicate
    return if applicant.blank? || job_posting.blank?

    exists = applicant.applications.active
                      .where(job_posting_id: job_posting_id).where.not(id: id).exists?
    errors.add(:base, "You've already applied to this role.") if exists
  end
end
