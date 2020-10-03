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
    begin
      puts "==================1"
      options = {
                  :message => "Please find attached here with the Bill copies of the #{params[:month]} - #{params[:year]}",
                  :subject => params[:subject],
                  :recipient_email => params[:recipient_email],
                  :current_brand => @current_brand.id,
                  :customer_bill_id => params[:id],
                  :month => params[:month],
                  :year => params[:year]
                }
      puts "==================2"              
      SendMonthlyBill.perform_async(options)
      # Mailer.send_archive_bills_via_email(options).deliver_now
      puts "==================3"
      flash.keep[:notice] = t("send_bills.mail_sent_success")
      puts "==================4"
      redirect_to :back
    rescue Exception => e
      puts "=================================="
      puts e.message
      puts "+++++++++++++++++++++++++++++++++"
    end
  end

end