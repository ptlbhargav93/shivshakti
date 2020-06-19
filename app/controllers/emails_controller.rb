class EmailsController < ApplicationController

  include ApplicationHelper
  
  before_action :authenticate_user!

  def send_invoice_to_accountant_via_email
    params[:recipient_email].each do |value|
      options = {
                  :message => params[:message],
                  :subject => params[:subject],
                  :recipient_email => value,
                  :current_brand => @current_brand.id,
                  :customer_bill_id => params[:id],
                  :date => params[:date]
                }
      Mailer.send_invoice_to_accountant_via_email(options).deliver_now
    end
    flash.keep[:notice] = t("send_bills.mail_sent_success")
    redirect_to :back
  end

end