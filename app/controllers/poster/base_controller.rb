module Poster
  # Every controller in the poster area inherits this gate — the role check lives in one
  # place that cannot be forgotten, never on individual actions.
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :require_job_poster

    private

    def require_job_poster
      return if current_user.job_poster?

      redirect_to applicant_dashboard_path, alert: "That area is for job posters."
    end
  end
end
