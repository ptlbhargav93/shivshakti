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
    @customer = Customer.new(customer_params.merge(:creator_id => current_user.id))
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
    elsif @customer.update(customer_params.merge(updater: current_user))
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
    if params[:search].present?
      search = session[:register_customer_search] = params[:search]
    else
      if params[:role].present?
        search = session[:register_customer_search] = nil
      else
        search = session[:register_customer_search] if session[:register_customer_search].present?
      end
    end

    if params[:city].present?
      city = session[:register_customer_city] = params[:city]
    else
      if params[:role].present?
        city = session[:register_customer_city] = nil
      else
        city = session[:register_customer_city] if session[:register_customer_city].present?
      end
    end

    if params[:state].present?
      state = session[:register_customer_state] = params[:state]
    else
      if params[:role].present?
        state = session[:register_customer_state] = nil
      else
        state = session[:register_customer_state] if session[:register_customer_state].present?
      end
    end
    if search.present?
      session[:register_customer_search] = search
      customers = customers.where('b_name LIKE :s or s_name LIKE :s', :s => "%#{search.delete(' ')}%")
    end
    if city.present?
      session[:register_customer_city] = city
      customers = customers.where('b_city LIKE :s or s_city LIKE :s', :s => "#{city.delete(' ')}%")
    end
    if state.present?
      session[:register_customer_state] = state
      customers = customers.where('b_state LIKE :s or s_state LIKE :s', :s => "#{state.delete(' ')}%")
    end
    customers = params[:order].present? ? customers.order("id #{params[:order]}").distinct : customers.order('id DESC')
  end

  def nav_header
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.desktop"), :arrowBack => true}
                        ]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_params
    params.require(:customer).permit(:b_name, :s_name, :b_gst_number, :s_gst_number, :b_address, :b_city, :b_state, :b_state_code, :b_pin_code, :b_country, :s_address, :s_city, :s_state, :s_tate_code, :s_pin_code, :s_country, :s_state_code, :is_shipping)
  end

end