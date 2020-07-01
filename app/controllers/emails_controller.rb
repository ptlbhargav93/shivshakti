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

  def send_archive_bills_via_email
    puts "==================1"
    options = {
                :message => "send_archive_bills_via_email",
                :subject => params[:subject],
                :recipient_email => params[:recipient_email],
                :current_brand => @current_brand.id,
                :customer_bill_id => params[:id],
                :month => params[:month],
                :year => params[:year]
              }
    puts "==================2"              
    SendMonthlyBillJob.perform_later options
    puts "==================3"
    flash.keep[:notice] = t("send_bills.mail_sent_success")
    puts "==================4"
    redirect_to :back
  end

end