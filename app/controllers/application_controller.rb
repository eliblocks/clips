class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_account

  def current_account
    current_user.account
  end

  protected
    def after_sign_in_path_for(resource)
      if request.referrer && request.referrer.gsub(/\?.*/, '') == landing_url
        video_id = params['video_id']
        embed_path(video_id) || root_path
      elsif request.env['omniauth.origin'].include?('preview')
        video_id = request.env['omniauth.origin'].match(/\/\d+/).to_s[1..-1]
        video_path(video_id)
      else
        super
      end
    end

    def after_inactive_sign_up_path_for(resource)
      library_path
    end

    def after_sign_up_path_for(resource)
      library_path
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :paypal_email, :category])
      devise_parameter_sanitizer.permit(:account_update, keys: [:full_name, :paypal_email, :category])
    end
end
