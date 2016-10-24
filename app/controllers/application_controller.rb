class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    #additional user params

    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :description])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :description])
  end
end
