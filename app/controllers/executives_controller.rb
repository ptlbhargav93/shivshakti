class ExecutivesController < ApplicationController

  before_action :authenticate_executive!
  before_action :nav_header, :only => [:resources_and_variables]
  before_filter :set_executive, only: [:show, :edit, :update, :destroy]

  def new
    @executive = User.new
  end

  def create
    remove_users_blank_resources
    secure_pass = SecureRandom.hex(6)
    @executive = User.new(executive_params.merge(:password =>secure_pass, :password_confirmation => secure_pass, :creator_id => current_user.id))
    if @executive.save
      redirect_to executive_path(@executive)
    else
      render 'new'
    end
  end

  def edit
    @step = params[:step] || 1
  end

  def update
    remove_users_blank_resources
    if not params[:user].present?
      @executive.update_attributes(:registered => true) unless @executive.registered
      redirect_to executives_path, :flash => { :notice => t("executive.executive_updated") }
    elsif @executive.update(executive_params.merge(updater: current_user))
      step = params[:proceed_next] ? (params[:step].to_i + 1) : (params[:step].to_i)
      flash.keep[:notice] = t("general.information_saved") if params[:save]
      redirect_to edit_executive_path(@executive, :step => step)
    else
      @step = params[:step]
      render 'edit'
    end
  end

  def destroy
    @executive.destroy
    respond_to do |format|
      format.html { redirect_to executives_url, notice: t("executive.executive_destroyed") }
      format.json { head :no_content }
    end
  end

  private

  def set_executive
    @executive = User.executives.find(params[:id])
  end

  def nav_header
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.desktop"), :arrowBack => true}
                        ]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def executive_params
    params.require(:user).permit(:email, :token, :password, :password_confirmation, :first_name, :last_name, :creator_id, :updater_id,
                                 resources_attributes: [:id, :media, :resource_type_id, :resource_spec_id, :_destroy])
  end

end