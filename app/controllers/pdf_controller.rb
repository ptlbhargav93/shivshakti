class PdfController < ApplicationController

  include ApplicationHelper

  include ActionView::Helpers::NumberHelper

  require 'currency-in-words'

  before_action :authenticate_user!

  before_action :set_pdf_asset_url

  def send_pdf
    @user = User.find(params[:id])
    subject = "#{@user.name.gsub(' ', '_')}"
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => (subject),
               :layout => "pdf.html",
               :template => "pdf/send_pdf.pdf.haml",
               :margin => { :top => 10, :bottom => 10, :left => 10, :right => 10},
               :viewport_size => '1280x1024',
               disposition: 'attachment'
      end
    end
  end

  def print_invoice
    @customer_bill = CustomerBill.find(params[:id])
    subject = t("send_bills.file_name_bill_archive_attachment",:name => @customer_bill.customer.b_name, :date => @customer_bill.invoice_date.strftime("%m/%Y"), :invoice_number => @customer_bill.invoice_number, :rate => @customer_bill.total_amount) 
    @without_image = params[:without_image].to_s || "false"
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => (subject),
               :layout => "pdf.html",
               :template => "pdf/print_invoice.pdf.haml",
               :margin => { :top => 10, :bottom => 10, :left => 10, :right => 10},
               :viewport_size => '1280x1024',
               disposition: 'attachment'
      end
    end
  end

  def print_receiving_copy
    @customer_bill = CustomerBill.find(params[:id])
    subject = t("send_bills.file_name_bill_archive_attachment_receiving_copy",:name => @customer_bill.customer.b_name, :date => @customer_bill.invoice_date.strftime("%m/%Y"), :invoice_number => @customer_bill.invoice_number, :rate => @customer_bill.total_amount) 
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => (subject),
               :layout => "pdf.html",
               :template => "pdf/print_receiving_copy.pdf.haml",
               :margin => { :top => 10, :bottom => 10, :left => 10, :right => 10},
               :viewport_size => '1280x1024',
               disposition: 'attachment'
      end
    end
  end

end