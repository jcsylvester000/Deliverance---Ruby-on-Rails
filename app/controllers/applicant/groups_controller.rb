module Applicant
  # Group chats: applicants create open groups and join others to prep together.
  class GroupsController < BaseController
    def index
      my_ids = current_user.conversation_participants.where(status: :accepted).pluck(:conversation_id)
      @my_groups = Conversation.where(kind: :group, id: my_ids).order(updated_at: :desc)
      @open_groups = Conversation.where(kind: :group).where.not(id: my_ids).order(created_at: :desc)
    end

    def create
      title = params[:title].to_s.strip
      if title.blank?
        return redirect_to applicant_groups_path, alert: "Give your group a name."
      end

      group = Conversation.create!(kind: :group, title: title, creator: current_user)
      group.conversation_participants.create!(user: current_user, status: :accepted, last_read_at: Time.current)
      redirect_to conversation_path(group), notice: "Group created — invite people by sharing it."
    end

    def join
      group = Conversation.where(kind: :group).find(params[:id])
      participant = group.conversation_participants.find_or_initialize_by(user: current_user)
      participant.update!(status: :accepted, last_read_at: Time.current)
      redirect_to conversation_path(group), notice: "You joined #{group.title}."
    end
  end
end
