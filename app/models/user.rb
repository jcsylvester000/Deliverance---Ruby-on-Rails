class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Q1 of the get-to-know-you modal — drives the role gate on the dashboards.
  enum :role, { job_poster: 0, applicant: 1 }
  # Q2 — "Representative of a Company Like HR" maps to company_representative.
  enum :organization_type, { agency: 0, individual: 1, company_representative: 2 }

  has_one :poster_profile,    dependent: :destroy
  has_one :applicant_profile, dependent: :destroy

  # A poster owns job postings and, through them, receives applications and hosts interviews.
  has_many :job_postings, foreign_key: :poster_id, inverse_of: :poster, dependent: :destroy
  has_many :received_applications, through: :job_postings, source: :applications
  has_many :hosted_interviews, through: :received_applications, source: :interview

  # An applicant owns their applications and attends interviews.
  has_many :applications, foreign_key: :applicant_id, inverse_of: :applicant, dependent: :destroy
  has_many :attending_interviews, through: :applications, source: :interview

  has_many :notifications, dependent: :destroy

  # Messaging.
  has_many :conversation_participants, dependent: :destroy
  has_many :conversations, through: :conversation_participants
  has_many :sent_messages, class_name: "Message", foreign_key: :sender_id, dependent: :destroy, inverse_of: :sender

  validates :role,              presence: true
  validates :organization_type, presence: true

  after_create :build_role_profile

  def display_name
    poster_profile&.company_name.presence ||
      applicant_profile&.headline.presence ||
      email.split("@").first
  end

  def discoverable?
    applicant? && applicant_profile&.discoverable?
  end

  # Who this user is allowed to start a conversation with (accept-only still applies).
  def can_message?(other)
    return false if other.nil? || other == self

    if job_poster?
      other.applicant? && received_applications.where(applicant_id: other.id).exists?
    else # applicant
      (other.applicant? && other.discoverable?) || other.job_poster?
    end
  end

  # Accepted conversations with messages the user hasn't read yet.
  def unread_conversations_count
    conversation_participants.select do |cp|
      next false unless cp.accepted?

      cutoff = cp.last_read_at || Time.at(0)
      cp.conversation.messages.where("created_at > ? AND sender_id <> ?", cutoff, id).exists?
    end.size
  end

  private

  def build_role_profile
    if job_poster?
      create_poster_profile! unless poster_profile
    else
      create_applicant_profile! unless applicant_profile
    end
  end
end
