module Applicant
  # The applicant's own application tracker (CRM). Everything is scoped to current_user.
  class ApplicationsController < BaseController
    before_action :set_application, only: [:withdraw, :onboarding]

    def index
      @applications = current_user.applications
                                  .includes(job_posting: { poster: :poster_profile })
                                  .recent
      @active_count = current_user.applications.active.count
    end

    def create
      job = JobPosting.visible.find(params[:job_posting_id])
      @application = current_user.applications.new(job_posting: job, cover_note: params[:cover_note])

      if @application.save
        @application.notify_applied!
        redirect_to applicant_applications_path, notice: "Applied to #{job.title}."
      else
        redirect_to job_path(job), alert: @application.errors.full_messages.to_sentence
      end
    end

    def withdraw
      @application.withdraw!
      redirect_to applicant_applications_path, notice: "Application withdrawn — a slot is free again."
    end

    # Hiring-time onboarding checklist (opens once at onboarding/hired stage).
    def onboarding
      unless @application.onboarding_active?
        return redirect_to applicant_applications_path, alert: "Onboarding isn't open for that application yet."
      end

      @documents = @application.onboarding_documents.index_by(&:kind)
    end

    private

    def set_application
      @application = current_user.applications.find(params[:id])
    end
  end
end
