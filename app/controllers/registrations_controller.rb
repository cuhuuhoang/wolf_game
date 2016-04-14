class RegistrationsController < Devise::RegistrationsController
  # before_filter :configure_permitted_parameters



  # def settings
  #   @user = current_user
  #   if @user
  #     render :settings
  #   else
  #     render file: 'public/404', status: 404, formats: [:html]
  #   end
  # end

  # protected
  #
  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.for(:settings) do |u|
  #     params[:user].permit(:full_name, :avatar, :skype, :facebook, :phone, :address, :dob)
  #   end
  # end
  #
  # def update_resource(resource, params)
  #   resource.update_without_password(params)
  # end

  private

  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end
end
