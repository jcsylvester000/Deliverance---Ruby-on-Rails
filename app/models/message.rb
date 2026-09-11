class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: "User"

  validates :body, presence: true

  after_create_commit :broadcast_and_touch

  private

  # Live-append to anyone viewing the thread, and bump the conversation for inbox ordering.
  def broadcast_and_touch
    conversation.touch
    broadcast_append_to(
      conversation, target: "messages",
      partial: "messages/message", locals: { message: self }
    )
  end
end
