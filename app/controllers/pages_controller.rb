class PagesController < ApplicationController
  before_action :authenticate_user!, only: :setting_up

  # Public landing page — shows the latest open roles and the "Login / Become Member" modal.
  def home
    return redirect_to dashboard_path_for(current_user) if user_signed_in?

    @jobs = JobPosting.visible.recent.includes(poster: :poster_profile).limit(6)
  end

  # The futuristic HUD interstitial shown right after sign-up, before the dashboard.
  def setting_up
    @destination = dashboard_path_for(current_user)
  end
end
