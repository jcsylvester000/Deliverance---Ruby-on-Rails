class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    convo = current_user.conversations.find(params[:conversation_id])

    unless convo.open_for?(current_user)
      return redirect_to conversation_path(convo), alert: "You can message once the request is accepted."
    end

    message = convo.messages.build(sender: current_user, body: params[:body])
    if message.save
      redirect_to conversation_path(convo)
    else
      redirect_to conversation_path(convo), alert: "Message can't be blank."
    end
  end
end
