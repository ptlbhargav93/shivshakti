class CustomerBillsController < ApplicationController

  before_action :authenticate_executive!
  before_action :nav_header, :only => [:resources_and_variables]
  before_filter :set_customer_bill, only: [:show, :edit, :update, :destroy]

  def index
    if params[:bill_customer].present?
      session[:bill_customer] = params[:bill_customer]
    end
    if session[:bill_customer]
      @customer = Customer.find(session[:bill_customer])
    end
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.start"), :arrowBack => false},
                          {:href => customers_path, :label => t("nav_header.customers"), :arrowBack => true}
                        ]
    @back_to_top = true
    @customer_bills = fetch_customer_bills.page(page).per(first_limit)
  end

  def customer_bill_filter
    @customer = Customer.find(session[:bill_customer])
    @customer_bills = fetch_customer_bills.page(page).per(first_limit)
  end

  def next_customer_bills
    @customer_bills = fetch_customer_bills.page(page).per(limit)
    render layout: false
  end  

  def new
    if not session[:bill_customer].present?
      redirect_to customers_path
    end
    @customer = Customer.find(session[:bill_customer])
    @customer_bill = CustomerBill.new
  end

  def create
    @customer_bill = CustomerBill.new(customer_bill_params.merge(:creator_id => current_user.id))
    if @customer_bill.save
      redirect_to customer_bill_path(@customer_bill)
    else
      @customer = Customer.find(session[:bill_customer])
      render 'new'
    end
  end

  def show
    nav_header
  end

  def edit
    nav_header
    @step = params[:step] || 1
  end

  def update
    if not params[:customer_bill].present?
      @customer_bill.update_attributes(:registered => true) unless @customer_bill.registered
      redirect_to customer_bills_path, :flash => { :notice => t("customer_bill.customer_bill_updated") }
    elsif @customer_bill.update(customer_bill_params.merge(updater: current_user))
      step = params[:proceed_next] ? (params[:step].to_i + 1) : (params[:step].to_i)
      flash.keep[:notice] = t("general.information_saved") if params[:save]
      redirect_to customer_bill_path(@customer_bill)
    else
      @step = params[:step]
      render 'edit'
    end
  end

  def destroy
    @customer_bill.destroy
    respond_to do |format|
      format.html { redirect_to customer_bills_url, notice: t("customer_bill.customer_bill_destroyed") }
      format.json { head :no_content }
    end
  end

  private

  def set_customer_bill
    @customer_bill = CustomerBill.find(params[:id])
  end

  def calculate_month_year
    unless params[:year].present? or params[:month].present?
      date = session[:billing_period].present? ? session[:billing_period].to_datetime : Date.today
      params[:year] = date.year
      params[:month] = date.month
    end
    @billing_period = Date.new(params[:year].to_i,params[:month].to_i)
    session[:billing_period] = @billing_period
  end

  def fetch_customer_bills
    if session[:bill_customer].present?
      customer = Customer.find(session[:bill_customer])
      customer_bills = customer.customer_bills
    else
      customer_bills = CustomerBill.all
    end
    
    if params[:search].present?
      search = session[:register_customer_bill_search] = params[:search]
    else
      if params[:role].present?
        search = session[:register_customer_bill_search] = nil
      else
        search = session[:register_customer_bill_search] if session[:register_customer_bill_search].present?
      end
    end
    if search.present?
      session[:register_customer_bill_search] = search
      customer_bills = customer_bills.where('invoice_number LIKE :s', :s => "%#{search.delete(' ')}%")
    end
    @years = customer_bills.select('extract(year from invoice_date) as year').group('year').map{|e| e.year}.compact.reject(&:blank?)
    calculate_month_year
    customer_bills = customer_bills.where('extract(year from invoice_date) = ? and extract(month from invoice_date) = ?', @billing_period.year, @billing_period.month)
    customer_bills = params[:order].present? ? customer_bills.order("id #{params[:order]}").distinct : customer_bills.order('id DESC')
  end

  def nav_header
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.desktop"), :arrowBack => false},
                          {:href => customers_path, :label => t("nav_header.customers"), :arrowBack => true}
                        ]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_bill_params
    params.require(:customer_bill).permit(:invoice_number, :lr_number, :po_number, :vendor_code, :invoice_date, :lr_date, :customer_id, :cgst, :sgst, :total_amount, :creator_id, :updater_id, customer_bill_products_attributes: [:id, :vehical_number, :ref_invoice_number, :from, :to, :quantity, :rate, :_destroy])
  end

end