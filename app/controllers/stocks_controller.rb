class StocksController < ApplicationController

  before_action :authenticate_executive!
  before_action :nav_header, :only => [:resources_and_variables]
  before_filter :set_stock, only: [:show, :edit, :update, :destroy]

  def index
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.start"), :arrowBack => false},
                          {:href => resources_and_variables_executives_path, :label => t("nav_header.resource_and_variable") , :arrowBack => true}
                        ]
    @back_to_top = true
    @stocks = fetch_stocks.page(page).per(first_limit)
  end

  def stock_filter
    @stocks = fetch_stocks.page(page).per(first_limit)
  end

  def next_stocks
    @stocks = fetch_stocks.page(page).per(limit)
    render layout: false
  end  

  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.new(stock_params.merge(:creator_id => current_user.id))
    if @stock.save
      redirect_to stock_path(@stock)
    else
      render 'new'
    end
  end

  def edit
    @step = params[:step] || 1
  end

  def update
    if not params[:stock].present?
      @stock.update_attributes(:registered => true) unless @stock.registered
      redirect_to stocks_path, :flash => { :notice => t("stock.stock_updated") }
    elsif @stock.update(stock_params.merge(updater: current_user))
      step = params[:proceed_next] ? (params[:step].to_i + 1) : (params[:step].to_i)
      flash.keep[:notice] = t("general.information_saved") if params[:save]
      redirect_to edit_stock_path(@stock, :step => step)
    else
      @step = params[:step]
      render 'edit'
    end
  end

  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url, notice: t("stock.stock_destroyed") }
      format.json { head :no_content }
    end
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def fetch_stocks
    stocks = Stock.all
    if params[:search].present?
      search = session[:register_stock_search] = params[:search]
    else
      search = session[:register_stock_search] if session[:register_stock_search].present?
    end
    if search.present?
      session[:register_stock_search] = search
      stocks = stocks.where('name LIKE :s or person_name LIKE :s or gst_number LIKE :s or CONCAT(name,person_name) LIKE :s', :s => "%#{search.delete(' ')}%")
    end
    stocks.order('id DESC').uniq
  end  

  def nav_header
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.desktop"), :arrowBack => true}
                        ]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def stock_params
    params.require(:stock).permit(:name, :person_name, :mobile_number1, :mobile_number2, :mobile_number3, :gst_number, :creator_id, :address,resources_attributes: [:id, :media, :resource_type_id, :resource_spec_id, :_destroy])
  end

end