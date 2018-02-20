class CustomerBillPaymentsController < ApplicationController

  before_action :authenticate_executive!
  before_action :nav_header, :only => [:resources_and_variables]
  before_filter :set_customer_bill_payment, only: [:show, :edit, :update, :destroy]

  def index
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.start"), :arrowBack => false},
                          {:href => resources_and_variables_executives_path, :label => t("nav_header.resource_and_variable") , :arrowBack => true}
                        ]
    @back_to_top = true
    @customer_bill_payments = fetch_customer_bill_payments.page(page).per(first_limit)
  end

  def customer_bill_payment_filter
    @customer_bill_payments = fetch_customer_bill_payments.page(page).per(first_limit)
  end

  def next_customer_bill_payments
    @customer_bill_payments = fetch_customer_bill_payments.page(page).per(limit)
    render layout: false
  end  

  def new
    @customer_bill_payment = CustomerBillPayment.new
  end

  def create
    @customer_bill_payment = CustomerBillPayment.new(customer_bill_payment_params.merge(:creator_id => current_user.id))
    if @customer_bill_payment.save
      redirect_to customer_bill_payment_path(@customer_bill_payment)
    else
      render 'new'
    end
  end

  def edit
    @step = params[:step] || 1
  end

  def update
    if not params[:customer_bill_payment].present?
      @customer_bill_payment.update_attributes(:registered => true) unless @customer_bill_payment.registered
      redirect_to customer_bill_payments_path, :flash => { :notice => t("customer_bill_payment.customer_bill_payment_updated") }
    elsif @customer_bill_payment.update(customer_bill_payment_params.merge(updater: current_user))
      step = params[:proceed_next] ? (params[:step].to_i + 1) : (params[:step].to_i)
      flash.keep[:notice] = t("general.information_saved") if params[:save]
      redirect_to edit_customer_bill_payment_path(@customer_bill_payment, :step => step)
    else
      @step = params[:step]
      render 'edit'
    end
  end

  def destroy
    @customer_bill_payment.destroy
    respond_to do |format|
      format.html { redirect_to customer_bill_payments_url, notice: t("customer_bill_payment.customer_bill_payment_destroyed") }
      format.json { head :no_content }
    end
  end

  private

  def set_customer_bill_payment
    @customer_bill_payment = CustomerBillPayment.find(params[:id])
  end

  def fetch_customer_bill_payments
    customer_bill_payments = CustomerBillPayment.all
    if params[:search].present?
      search = session[:register_customer_bill_payment_search] = params[:search]
    else
      search = session[:register_customer_bill_payment_search] if session[:register_customer_bill_payment_search].present?
    end
    if search.present?
      session[:register_customer_bill_payment_search] = search
      customer_bill_payments = customer_bill_payments.where('name LIKE :s or person_name LIKE :s or gst_number LIKE :s or CONCAT(name,person_name) LIKE :s', :s => "%#{search.delete(' ')}%")
    end
    customer_bill_payments.order('id DESC').uniq
  end  

  def nav_header
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.desktop"), :arrowBack => true}
                        ]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_bill_payment_params
    params.require(:customer_bill_payment).permit(:name, :person_name, :mobile_number1, :mobile_number2, :mobile_number3, :gst_number, :creator_id, :address,resources_attributes: [:id, :media, :resource_type_id, :resource_spec_id, :_destroy])
  end

end