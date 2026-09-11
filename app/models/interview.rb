class Interview < ApplicationRecord
  belongs_to :application

  enum :mode,   { online: 0, onsite: 1, phone: 2 }
  enum :status, { scheduled: 0, completed: 1, cancelled: 2 }

  validates :scheduled_at, presence: true
  validates :duration_minutes, numericality: { greater_than: 0 }

  delegate :applicant, :job_posting, to: :application

  scope :upcoming, -> { where(status: :scheduled).where("scheduled_at >= ?", Time.current).order(:scheduled_at) }

  def poster
    job_posting.poster
  end

  def ends_at
    scheduled_at + duration_minutes.minutes
  end

  def mode_label
    mode.to_s.humanize.titleize
  end

  # Notify the applicant that an interview was set (or reset).
  def notify_scheduled!
    Notification.create!(user: applicant, kind: :interview_scheduled, notifiable: self)
  end

  def notify_cancelled!
    Notification.create!(user: applicant, kind: :interview_cancelled, notifiable: self)
  end
end
