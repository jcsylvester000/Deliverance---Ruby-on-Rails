module Poster
  class DashboardsController < BaseController
    def show
      @profile = current_user.poster_profile
    end
  end
end
