class Conversation < ApplicationRecord
  # scopes: false avoids generating a `.group` class method that collides with ActiveRecord's own.
  enum :kind, { direct: 0, group: 1 }, scopes: false

  belongs_to :creator, class_name: "User"
  has_many :conversation_participants, dependent: :destroy
  has_many :participants, through: :conversation_participants, source: :user
  has_many :messages, dependent: :destroy

  scope :recent, -> { order(updated_at: :desc) }

  # The existing 1:1 direct conversation between two users, if any.
  def self.direct_between(a, b)
    where(kind: :direct).joins(:conversation_participants)
          .where(conversation_participants: { user_id: [a.id, b.id] })
          .group("conversations.id")
          .having("COUNT(DISTINCT conversation_participants.user_id) = 2")
          .first
  end

  def participant_for(user)
    conversation_participants.detect { |p| p.user_id == user.id } ||
      conversation_participants.find_by(user_id: user.id)
  end

  def other_participant(user)
    conversation_participants.detect { |p| p.user_id != user.id }
  end

  def accepted_by_all?
    conversation_participants.all?(&:accepted?)
  end

  def pending_for?(user)
    participant_for(user)&.invited?
  end

  def blocked?
    conversation_participants.any?(&:blocked?)
  end

  # Direct threads open only once both sides accept; a group is open to any accepted member.
  def open_for?(user)
    p = participant_for(user)
    return false unless p&.accepted?

    direct? ? accepted_by_all? : true
  end

  def member?(user)
    participant_for(user)&.accepted?
  end

  def member_names
    conversation_participants.select(&:accepted?).map { |p| p.user.display_name }
  end

  def title_for(user)
    return title.presence || "Group chat" if group?

    other_participant(user)&.user&.display_name || "Conversation"
  end
end
