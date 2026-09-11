class ConversationParticipant < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  enum :status, { invited: 0, accepted: 1, declined: 2, blocked: 3 }
end
