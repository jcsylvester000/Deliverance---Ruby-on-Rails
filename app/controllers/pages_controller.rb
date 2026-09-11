class PagesController < ApplicationController
  before_action :authenticate_user!, only: :setting_up

  # Public landing page — shows the latest open roles, a few blog previews,
  # and the "Login / Become a Member" modal.
  def home
    return redirect_to dashboard_path_for(current_user) if user_signed_in?

    @jobs = JobPosting.visible.recent.includes(poster: :poster_profile).limit(6)
    @articles = Article.all.first(3)
  end

  # Public "why become a member" marketing page.
  def membership
    @articles = Article.all.first(3)
  end

  # Public "about us" page.
  def about
  end

  # The futuristic HUD interstitial shown right after sign-up, before the dashboard.
  def setting_up
    @destination = dashboard_path_for(current_user)
  end
end
