class CustomersController < ApplicationController

  before_action :authenticate_executive!
  before_action :nav_header, :only => [:resources_and_variables]
  before_filter :set_customer, only: [:show, :edit, :update, :destroy]

  def index
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.start"), :arrowBack => true}
                        ]
    @back_to_top = true
    @customers = fetch_customers.page(page).per(first_limit)
  end

  def customer_filter
    @customers = fetch_customers.page(page).per(first_limit)
  end

  def next_customers
    @customers = fetch_customers.page(page).per(limit)
    render layout: false
  end  

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(deep_transform_values(customer_params).merge(:creator_id => current_user.id))
    if @customer.save
      redirect_to customer_path(@customer)
    else
      render 'new'
    end
  end

  def edit
    @step = params[:step] || 1
  end

  def update
    if not params[:customer].present?
      @customer.update_attributes(:registered => true) unless @customer.registered
      redirect_to customers_path, :flash => { :notice => t("customer.customer_updated") }
    elsif @customer.update(deep_transform_values(customer_params).merge(updater: current_user))
      step = params[:proceed_next] ? (params[:step].to_i + 1) : (params[:step].to_i)
      flash.keep[:notice] = t("general.information_saved") if params[:save]
      redirect_to customer_path(@customer)
    else
      @step = params[:step]
      render 'edit'
    end
  end

  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: t("customer.customer_destroyed") }
      format.json { head :no_content }
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def fetch_customers
    customers = Customer.all
    search = params[:search] if params[:search].present?
    ref_search = params[:ref_search] if params[:ref_search].present?
    city = params[:city] if params[:city].present?
    state = params[:state] if params[:state].present?
    customers = customers.where('b_name ILIKE :s', :s => "%#{search}%") if search.present?
    customers = customers.where('ref_customer ILIKE :s', :s => "%#{ref_search}%") if ref_search.present?
    customers = customers.where('b_city ILIKE :s', :s => "#{city}%") if city.present?
    customers = customers.where('b_state ILIKE :s', :s => "#{state}%") if state.present?
    customers = customers.order('id DESC')
  end

  def nav_header
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.desktop"), :arrowBack => true}
                        ]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_params
    params.require(:customer).permit(:b_name, :s_name, :b_gst_number, :s_gst_number, :b_address, :b_city, :b_state, :b_state_code, :b_pin_code, :b_country, :s_address, :s_city, :s_state, :s_tate_code, :s_pin_code, :s_country, :s_state_code, :is_shipping, :ref_customer)
  end

end