class IncomeExpensesController < ApplicationController

  before_action :authenticate_executive!
  before_action :nav_header, :only => [:resources_and_variables]
  before_filter :set_income_expense, only: [:show, :edit, :update, :destroy]

  def index
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.start"), :arrowBack => false},
                          {:href => resources_and_variables_executives_path, :label => t("nav_header.resource_and_variable") , :arrowBack => true}
                        ]
    @back_to_top = true
    @income_expenses = fetch_income_expenses.page(page).per(first_limit)
  end

  def income_expense_filter
    @income_expenses = fetch_income_expenses.page(page).per(first_limit)
  end

  def next_income_expenses
    @income_expenses = fetch_income_expenses.page(page).per(limit)
    render layout: false
  end  

  def new
    @income_expense = IncomeExpense.new
  end

  def create
    @income_expense = IncomeExpense.new(income_expense_params.merge(:creator_id => current_user.id))
    if @income_expense.save
      redirect_to income_expense_path(@income_expense)
    else
      render 'new'
    end
  end

  def edit
    @step = params[:step] || 1
  end

  def update
    if not params[:income_expense].present?
      @income_expense.update_attributes(:registered => true) unless @income_expense.registered
      redirect_to income_expenses_path, :flash => { :notice => t("income_expense.income_expense_updated") }
    elsif @income_expense.update(income_expense_params.merge(updater: current_user))
      step = params[:proceed_next] ? (params[:step].to_i + 1) : (params[:step].to_i)
      flash.keep[:notice] = t("general.information_saved") if params[:save]
      redirect_to edit_income_expense_path(@income_expense, :step => step)
    else
      @step = params[:step]
      render 'edit'
    end
  end

  def destroy
    @income_expense.destroy
    respond_to do |format|
      format.html { redirect_to income_expenses_url, notice: t("income_expense.income_expense_destroyed") }
      format.json { head :no_content }
    end
  end

  private

  def set_income_expense
    @income_expense = IncomeExpense.find(params[:id])
  end

  def fetch_income_expenses
    income_expenses = IncomeExpense.all
    if params[:search].present?
      search = session[:register_income_expense_search] = params[:search]
    else
      search = session[:register_income_expense_search] if session[:register_income_expense_search].present?
    end
    if search.present?
      session[:register_income_expense_search] = search
      income_expenses = income_expenses.where('name LIKE :s or person_name LIKE :s or gst_number LIKE :s or CONCAT(name,person_name) LIKE :s', :s => "%#{search.delete(' ')}%")
    end
    income_expenses.order('id DESC').uniq
  end  

  def nav_header
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.desktop"), :arrowBack => true}
                        ]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def income_expense_params
    params.require(:income_expense).permit(:name, :person_name, :mobile_number1, :mobile_number2, :mobile_number3, :gst_number, :creator_id, :address,resources_attributes: [:id, :media, :resource_type_id, :resource_spec_id, :_destroy])
  end

end