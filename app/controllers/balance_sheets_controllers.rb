class BalanceSheetsController < ApplicationController

  before_action :authenticate_executive!
  before_action :nav_header, :only => [:resources_and_variables]
  before_filter :set_balance_sheet, only: [:show, :edit, :update, :destroy]

  def index
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.start"), :arrowBack => false},
                          {:href => resources_and_variables_executives_path, :label => t("nav_header.resource_and_variable") , :arrowBack => true}
                        ]
    @back_to_top = true
    @balance_sheets = fetch_balance_sheets.page(page).per(first_limit)
  end

  def balance_sheet_filter
    @balance_sheets = fetch_balance_sheets.page(page).per(first_limit)
  end

  def next_balance_sheets
    @balance_sheets = fetch_balance_sheets.page(page).per(limit)
    render layout: false
  end  

  def new
    @balance_sheet = BalanceSheet.new
  end

  def create
    @balance_sheet = BalanceSheet.new(balance_sheet_params.merge(:creator_id => current_user.id))
    if @balance_sheet.save
      redirect_to balance_sheet_path(@balance_sheet)
    else
      render 'new'
    end
  end

  def edit
    @step = params[:step] || 1
  end

  def update
    if not params[:balance_sheet].present?
      @balance_sheet.update_attributes(:registered => true) unless @balance_sheet.registered
      redirect_to balance_sheets_path, :flash => { :notice => t("balance_sheet.balance_sheet_updated") }
    elsif @balance_sheet.update(balance_sheet_params.merge(updater: current_user))
      step = params[:proceed_next] ? (params[:step].to_i + 1) : (params[:step].to_i)
      flash.keep[:notice] = t("general.information_saved") if params[:save]
      redirect_to edit_balance_sheet_path(@balance_sheet, :step => step)
    else
      @step = params[:step]
      render 'edit'
    end
  end

  def destroy
    @balance_sheet.destroy
    respond_to do |format|
      format.html { redirect_to balance_sheets_url, notice: t("balance_sheet.balance_sheet_destroyed") }
      format.json { head :no_content }
    end
  end

  private

  def set_balance_sheet
    @balance_sheet = BalanceSheet.find(params[:id])
  end

  def fetch_balance_sheets
    balance_sheets = BalanceSheet.all
    if params[:search].present?
      search = session[:register_balance_sheet_search] = params[:search]
    else
      search = session[:register_balance_sheet_search] if session[:register_balance_sheet_search].present?
    end
    if search.present?
      session[:register_balance_sheet_search] = search
      balance_sheets = balance_sheets.where('name LIKE :s or person_name LIKE :s or gst_number LIKE :s or CONCAT(name,person_name) LIKE :s', :s => "%#{search.delete(' ')}%")
    end
    balance_sheets.order('id DESC').uniq
  end  

  def nav_header
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.desktop"), :arrowBack => true}
                        ]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def balance_sheet_params
    params.require(:balance_sheet).permit(:name, :person_name, :mobile_number1, :mobile_number2, :mobile_number3, :gst_number, :creator_id, :address,resources_attributes: [:id, :media, :resource_type_id, :resource_spec_id, :_destroy])
  end

end