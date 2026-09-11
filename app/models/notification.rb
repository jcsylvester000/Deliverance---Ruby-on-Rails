class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  enum :kind, {
    application_received: 0,        # → poster: someone applied
    application_advanced: 1,        # → applicant: moved forward
    application_rejected: 2,        # → applicant: not selected
    application_withdrawn: 3,       # → poster: applicant withdrew
    interview_scheduled: 4,         # → applicant: interview set/reset
    interview_cancelled: 5,         # → applicant: interview cancelled
    onboarding_document_uploaded: 6,# → poster: applicant uploaded an onboarding doc
    message_request: 7              # → recipient: someone wants to connect
  }

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  after_create_commit :broadcast_arrival

  ICONS = {
    "application_received"         => "📥",
    "application_advanced"         => "⏫",
    "application_rejected"         => "🚫",
    "application_withdrawn"        => "↩️",
    "interview_scheduled"          => "📅",
    "interview_cancelled"          => "❌",
    "onboarding_document_uploaded" => "📎",
    "message_request"              => "💬"
  }.freeze

  def icon
    ICONS[kind] || "🔔"
  end

  def read?
    read_at.present?
  end

  def mark_read!
    update!(read_at: Time.current) unless read?
  end

  private

  # Live-update the recipient's bell badge and prepend to their open notifications list.
  def broadcast_arrival
    broadcast_replace_to([user, :notifications],
                         target: "notifications-bell",
                         partial: "notifications/bell", locals: { user: user })
    broadcast_prepend_to([user, :notifications],
                         target: "notifications-list",
                         partial: "notifications/notification", locals: { notification: self })
  end
end
