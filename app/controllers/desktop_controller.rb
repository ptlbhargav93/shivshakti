class DesktopController < ApplicationController
  layout 'desktop'
  def index
  	
    # respond_to do |format|
    #   format.html {render :layout => 'desktop'}
    # end  	
    if current_user.present? 
    	get_desktop_redirection_path current_user
    end
  end

  def get_desktop_redirection_path current_user
    user_role = current_user.role.downcase.pluralize
    path = "desktop_#{user_role}_path"
    ["executives","staffs"].include?(user_role) ? (redirect_to eval("#{path}")) :  (redirect_to sign_in_path)
  end
end