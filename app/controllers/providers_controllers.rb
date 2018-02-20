class ProvidersController < ApplicationController

  before_action :authenticate_executive!
  before_action :nav_header, :only => [:resources_and_variables]
  before_filter :set_provider, only: [:show, :edit, :update, :destroy]

  def index
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.start"), :arrowBack => true}
                        ]
    @back_to_top = true
    @providers = fetch_providers.page(page).per(first_limit)
  end

  def provider_filter
    @providers = fetch_providers.page(page).per(first_limit)
  end

  def next_providers
    @providers = fetch_providers.page(page).per(limit)
    render layout: false
  end  

  def new
    @provider = Provider.new
  end

  def create
    @provider = Provider.new(provider_params.merge(:creator_id => current_user.id))
    if @provider.save
      redirect_to provider_path(@provider)
    else
      render 'new'
    end
  end

  def edit
    @step = params[:step] || 1
  end

  def update
    if not params[:provider].present?
      @provider.update_attributes(:registered => true) unless @provider.registered
      redirect_to providers_path, :flash => { :notice => t("provider.provider_updated") }
    elsif @provider.update(provider_params.merge(updater: current_user))
      step = params[:proceed_next] ? (params[:step].to_i + 1) : (params[:step].to_i)
      flash.keep[:notice] = t("general.information_saved") if params[:save]
      redirect_to edit_provider_path(@provider, :step => step)
    else
      @step = params[:step]
      render 'edit'
    end
  end

  def destroy
    @provider.destroy
    respond_to do |format|
      format.html { redirect_to providers_url, notice: t("provider.provider_destroyed") }
      format.json { head :no_content }
    end
  end

  private

  def set_provider
    @provider = Provider.find(params[:id])
  end

  def fetch_providers
    providers = Provider.all
    if params[:search].present?
      search = session[:register_provider_search] = params[:search]
    else
      search = session[:register_provider_search] if session[:register_provider_search].present?
    end
    if search.present?
      session[:register_provider_search] = search
      providers = providers.where('name LIKE :s or person_name LIKE :s or gst_number LIKE :s or CONCAT(name,person_name) LIKE :s', :s => "%#{search.delete(' ')}%")
    end
    providers.order('id DESC').uniq
  end  

  def nav_header
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.desktop"), :arrowBack => true}
                        ]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def provider_params
    params.require(:provider).permit(:name, :person_name, :mobile_number1, :mobile_number2, :mobile_number3, :gst_number, :creator_id, :address,resources_attributes: [:id, :media, :resource_type_id, :resource_spec_id, :_destroy])
  end

end