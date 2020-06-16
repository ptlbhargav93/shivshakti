class PdfController < ApplicationController

  include ApplicationHelper

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
    subject = "#{@customer_bill.customer.b_name.gsub(' ', '_')}"
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

end