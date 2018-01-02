class UserController < ApplicationController

  before_filter :authenticate_user!, :except => [:show]
  before_action :get_user, :only => [:edit, :update_password]

  def edit
  end

  def update_password
    if @user.update_attributes(user_params)
      redirect_to @back_path, :flash => { :notice => I18n.t("general.password_updated_successfully") }
    else
      render "edit"
    end
  end

  def edit_profile
  end
  
  def update_profile
    if current_user.update_attributes(edit_user_params)
      redirect_to edit_profile_path, :flash => { :notice => I18n.t("general.profile_updated_successfully") }
    else
      render "edit_profile"
    end
  end

  def update_old_password
    @user = current_user
    if @user.valid_password? params[:old_password]
      if @user.update_attributes(:password => params[:new_password], :password_confirmation => params[:password_confirmation])
        sign_in(current_user, :bypass => true)
        flash[:notice] = I18n.t("general.password_updated_successfully");
        render :js => "window.location = '#{personal_settings_path}'"
      end
    else
      @user.errors[:invalid_current_password] << I18n.t("general.invalid_current_password");
      respond_to do |format|
        format.js { render :layout => false }
      end
    end
  end

  private

  def get_user
    @user = @current_brand.users.find(params[:id])
    @back_path = get_user_type_redirection_path @user
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :reset_password_token)
  end

  def edit_user_params
    params.require(:user).permit(:first_name, :last_name, :avatar)
  end
end
