class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # New members go through the HUD "setting up your dashboard" transition first.
  def after_sign_up_path_for(_resource)
    setting_up_path
  end

  def after_inactive_sign_up_path_for(_resource)
    setting_up_path
  end
end
