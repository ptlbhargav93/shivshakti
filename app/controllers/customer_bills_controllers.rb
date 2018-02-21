class CustomerBillsController < ApplicationController

  before_action :authenticate_executive!
  before_action :nav_header, :only => [:resources_and_variables]
  before_filter :set_customer_bill, only: [:show, :edit, :update, :destroy]

  def index
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
    @customer_bill = CustomerBill.new
  end

  def create
    @customer_bill = CustomerBill.new(customer_bill_params.merge(:creator_id => current_user.id))
    if @customer_bill.save
      redirect_to customer_bill_path(@customer_bill)
    else
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
      redirect_to edit_customer_bill_path(@customer_bill, :step => step)
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
    customer_bills = CustomerBill.all
    if params[:search].present?
      search = session[:register_customer_bill_search] = params[:search]
    else
      search = session[:register_customer_bill_search] = nil
    end
    if search.present?
      session[:register_customer_bill_search] = search
      customer_bills = customer_bills.where('name LIKE :s or person_name LIKE :s or gst_number LIKE :s or CONCAT(name,person_name) LIKE :s', :s => "%#{search.delete(' ')}%")
    end
    customer_bills.order('id DESC').uniq
  end  

  def nav_header
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.desktop"), :arrowBack => true}
                        ]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_bill_params
    params.require(:customer_bill).permit(:name, :person_name, :mobile_number1, :mobile_number2, :mobile_number3, :gst_number, :creator_id, :address,resources_attributes: [:id, :media, :resource_type_id, :resource_spec_id, :_destroy])
  end

end