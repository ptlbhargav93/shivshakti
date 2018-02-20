class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  def sign_in_by_token
    user = User.where(:token => params[:token]).first()
    if user.present?
      sign_in user
    end
    redirect_to root_path
  end
  
  private 

  def after_sign_in_path_for(resource)
    #session[:current_brand_slug] = resource.brand.slug
    flash[:notice] = t("devise.sessions.signed_in")
    root_path
  end
end
