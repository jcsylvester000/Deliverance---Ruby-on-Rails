module Applicant
  # The applicant area's role gate — inherited by every controller here.
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :require_applicant

    private

    def require_applicant
      return if current_user.applicant?

      redirect_to poster_dashboard_path, alert: "That area is for applicants."
    end
  end
end
