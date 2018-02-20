class CustomersController < ApplicationController

  before_action :authenticate_executive!
  before_action :nav_header, :only => [:resources_and_variables]
  before_filter :set_customer, only: [:show, :edit, :update, :destroy]

  def index
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.start"), :arrowBack => false},
                          {:href => resources_and_variables_executives_path, :label => t("nav_header.resource_and_variable") , :arrowBack => true}
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
      redirect_to edit_customer_path(@customer, :step => step)
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
      search = session[:register_customer_search] if session[:register_customer_search].present?
    end
    if search.present?
      session[:register_customer_search] = search
      customers = customers.where('name LIKE :s or person_name LIKE :s or gst_number LIKE :s or CONCAT(name,person_name) LIKE :s', :s => "%#{search.delete(' ')}%")
    end
    customers.order('id DESC').uniq
  end  

  def nav_header
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.desktop"), :arrowBack => true}
                        ]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_params
    params.require(:customer).permit(:name, :person_name, :mobile_number1, :mobile_number2, :mobile_number3, :gst_number, :creator_id, :address,resources_attributes: [:id, :media, :resource_type_id, :resource_spec_id, :_destroy])
  end

end