class Mailer < ActionMailer::Base

  include ApplicationHelper

  default :from => "'#{I18n.t('dbm_email')}' <no-reply@fenux.fi>"

  def send_feedback_email(options={})
    @message = options[:message]
    I18n.with_locale(I18n.locale) do
      mail(:to => options[:recipient_emails], :subject => options[:subject])
    end
  end

  def send_order_email_for_user(options={})
    @message = options[:message]
    I18n.with_locale(I18n.locale) do
      mail(:to => options[:recipient_email], :subject => options[:subject])
    end
  end
  
  def send_login_info_by_email(options)
    @message = options[:message]
    I18n.with_locale(I18n.locale) do
      mail(:to => options[:recipient_email], :subject => options[:subject])
    end
  end

  def send_invoice_via_email(options)
    @message = options[:message]
    temp_folder = options[:temp_folder]
    @current_brand = Brand.find_by_id options[:current_brand]
    @send_bill = UserBill.find(options[:send_bill_id])

    invoice_pdf_name = t("send_bills.copy_of_invoice_date",:date => @send_bill.billing_period.strftime("%m/%Y")) 
    reward_pdf_name = t("send_bills.copy_of_reward_detail",:date => @send_bill.billing_period.strftime("%m/%Y")) 
    
    invoice_content = render_to_string(:layout => "pdf.html", :template => 'pdf/print_invoice.pdf.haml')
    reward_content = render_to_string(:layout => "pdf.html", :template => 'pdf/reward_detail.pdf.haml')
    
    attachments["#{invoice_pdf_name}.pdf"] = WickedPdf.new.pdf_from_string(
      invoice_content,  pdf: "#{t("send_bills.copy_of_invoice")}",
                              viewport_size: '1280x1024',
                              :margin => { :top => 10, :bottom => 3, :left => 10, :right => 10})
    
    attachments["#{reward_pdf_name}.pdf"] = WickedPdf.new.pdf_from_string(
      reward_content,  pdf: "#{t("send_bills.copy_of_reward_detail")}",
                              viewport_size: '1280x1024',
                              :margin => { :top => 10, :bottom => 3, :left => 10, :right => 10})
    if temp_folder.present?
      Dir["#{temp_folder}/*"].each do |sourcefile|
        next if File.directory? sourcefile
        original_filename = sourcefile.split("/").last
        attachments[original_filename] = File.read(sourcefile)
      end
    end
    I18n.with_locale(I18n.locale) do
      mail(:to => options[:recipient_email], :subject => options[:subject])
    end
    sleep(1)
    temp_folder = options[:temp_folder]
    if temp_folder.present?
      FileUtils.rm_rf(temp_folder) if File.exists?(temp_folder)
    end
  end
end