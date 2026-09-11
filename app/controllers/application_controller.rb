class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps,
  # CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Let the get-to-know-you modal pass its three answers through Devise sign-up.
  def configure_permitted_parameters
    extra = [:role, :organization_type, :heard_from]
    devise_parameter_sanitizer.permit(:sign_up, keys: extra)
    devise_parameter_sanitizer.permit(:account_update, keys: extra)
  end

  # After signing in, land on the dashboard that matches the role.
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || dashboard_path_for(resource)
  end

  def dashboard_path_for(user)
    user.job_poster? ? poster_dashboard_path : applicant_dashboard_path
  end
  helper_method :dashboard_path_for

  # The month a calendar view is showing (defaults to the current month).
  def month_param
    Date.parse(params[:month].to_s).beginning_of_month
  rescue ArgumentError, TypeError
    Date.current.beginning_of_month
  end
end
