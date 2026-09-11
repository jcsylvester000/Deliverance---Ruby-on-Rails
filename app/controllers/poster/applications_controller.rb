module Poster
  # The poster's pipeline CRM — applications across all their postings. Scoped to
  # current_user.received_applications, so a poster only ever sees their own inbound leads.
  class ApplicationsController < BaseController
    before_action :set_application, only: [:show, :advance, :reject]

    def index
      @applications = current_user.received_applications
                                  .includes(:applicant, :job_posting)
                                  .recent
      if Application.stages.key?(params[:stage])
        @applications = @applications.where(stage: params[:stage])
        @stage = params[:stage]
      end
      raw = current_user.received_applications.group(:stage).count
      @counts = raw.transform_keys { |k| k.is_a?(Integer) ? Application.stages.key(k) : k }
    end

    def show; end

    def advance
      if @application.advance!
        redirect_back fallback_location: poster_application_path(@application),
                      notice: "Moved to #{@application.stage_label}."
      else
        redirect_back fallback_location: poster_application_path(@application),
                      alert: "This application is already at the final stage."
      end
    end

    def reject
      @application.reject!
      redirect_back fallback_location: poster_applications_path, notice: "Application rejected."
    end

    private

    def set_application
      @application = current_user.received_applications.find(params[:id])
    end
  end
end
