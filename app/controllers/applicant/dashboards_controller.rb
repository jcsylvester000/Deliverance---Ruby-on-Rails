module Applicant
  class DashboardsController < BaseController
    def show
      @profile = current_user.applicant_profile
    end
  end
end
