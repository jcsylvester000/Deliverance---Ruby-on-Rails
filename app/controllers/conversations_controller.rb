class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show, :accept, :decline, :block]

  def index
    parts = current_user.conversation_participants.includes(conversation: { conversation_participants: :user })
    @requests = parts.select(&:invited?).map(&:conversation)
    @threads  = parts.select(&:accepted?).map(&:conversation).sort_by(&:updated_at).reverse
  end

  def show
    @messages = @conversation.messages.order(:created_at).includes(:sender)
    mark_read!
  end

  # Start (or reopen) a direct conversation with an optional intro message.
  def create
    recipient = User.find(params[:recipient_id])
    unless current_user.can_message?(recipient)
      return redirect_back fallback_location: conversations_path, alert: "You can't message that person."
    end

    convo = Conversation.direct_between(current_user, recipient)
    if convo.nil?
      convo = Conversation.create!(kind: :direct, creator: current_user)
      convo.conversation_participants.create!(user: current_user, status: :accepted, last_read_at: Time.current)
      convo.conversation_participants.create!(user: recipient, status: :invited)
      if params[:body].present?
        message = convo.messages.create!(sender: current_user, body: params[:body])
        Notification.create!(user: recipient, kind: :message_request, notifiable: message)
      end
    end
    redirect_to conversation_path(convo)
  end

  def accept
    my_participant.update!(status: :accepted, last_read_at: Time.current)
    redirect_to conversation_path(@conversation), notice: "Request accepted — say hello."
  end

  def decline
    my_participant.update!(status: :declined)
    redirect_to conversations_path, notice: "Request declined."
  end

  def block
    my_participant.update!(status: :blocked)
    redirect_to conversations_path, notice: "Blocked — their messages won't come through."
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:id])
  end

  def my_participant
    @conversation.participant_for(current_user)
  end

  def mark_read!
    my_participant&.update(last_read_at: Time.current)
  end
end
