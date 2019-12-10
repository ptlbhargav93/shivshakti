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
                          {:href => root_path, :label => t("nav_header.start"), :arrowBack => true}
                        ]
    @back_to_top = true
    @customer_bills = fetch_customer_bills.page(page).per(first_limit)
  end

  def customer_bill_filter
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
    # raise @customer_bill.inspect
    if @customer_bill.save!
      redirect_to customer_bill_path(@customer_bill)
    else
      @customer = Customer.find(session[:bill_customer])
      render 'new'
    end
  end

  def edit
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
      customer_bills = customer_bills.joins(:customer)
      search.split(' ').each do |s|
        if s.present?
          customer_bills = customer_bills.where('customer_bills.invoice_number LIKE :s or customers.name LIKE :s or customers.address1 LIKE :s or customers.gst_number LIKE :s or customers.phone_number LIKE :s or customers.address2 LIKE :s', :s => "%#{s}%")
        end
      end
    end
    customer_bills.order('customer_bills.invoice_date DESC').uniq
  end

  def nav_header
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.desktop"), :arrowBack => true}
                        ]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_bill_params
    params.require(:customer_bill).permit(:invoice_number, :lr_number, :invoice_date, :customer_id, :total_amount, :creator_id, :updater_id, customer_bill_products_attributes: [:id, :vehical_number, :ref_invoice_number, :from, :to, :quantity, :rate, :_destroy])
  end

end