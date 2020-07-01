class Mailer < ActionMailer::Base

  include ApplicationHelper

  default :from => "'#{I18n.t('dbm_email')}' <shiv.shaktiahm@gmail.com>"

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

  def send_archive_bills_via_email(options={})
    puts "=====send_archive_bills_via_email"
    puts options.inspect
    puts options["year"].inspect
    puts options["month"].inspect
    puts "================="
    @message = "test mail"

    if options["year"].present? and options["month"].present?
      puts "=====send_archive_bills_via_email -- 2"
      customer_bills = CustomerBill.where('extract(year from invoice_date) = ? and extract(month from invoice_date) = ?', options["year"], options["month"])
      directory = "#{Rails.root}/public/pdfs/" # full path-to-unzipped-dir
      FileUtils.rm_f Dir.glob("#{directory}*")
      customer_bills.each do |bill|
        puts "------#{bill.id}"
        @customer_bill = bill
        invoice_pdf_name = t("send_bills.file_name_bill_archive_attachment",:name => @customer_bill.customer.try(:b_name), :date => @customer_bill.invoice_date.strftime("%m/%Y"), :invoice_number => @customer_bill.invoice_number, :rate => @customer_bill.total_amount) 
        invoice_content = render_to_string(:layout => "pdf.html", :template => 'pdf/print_invoice.pdf.haml')
        pdf = WickedPdf.new.pdf_from_string(
            invoice_content,  pdf: invoice_pdf_name,
                                    viewport_size: '1280x1024',
                                    :margin => { :top => 10, :bottom => 3, :left => 10, :right => 10})
        # then save to a file
        save_path = Rails.root.join('public/pdfs/',"#{invoice_pdf_name}.pdf")
        File.open(save_path, 'wb') do |file|
          file << pdf
        end
      end
      file_name = "#{options["month"]}_#{options["year"]}_bill_archive_#{DateTime.now.to_i}.zip"
      puts "=====send_archive_bills_via_email -- file_name"
      puts file_name.inspect
      puts "======================================="
      zipfile_name = "#{directory}/#{file_name}" # full path-to-zip-file
      puts "=====send_archive_bills_via_email -- zipfile_name"
      puts zipfile_name.inspect
      puts "======================================="

      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        Dir[File.join(directory, '*')].each do |file|
          zipfile.add(file.sub(directory, ''), file)
        end
      end
      @message = options["message"]
      @current_brand = Brand.find_by_id options["current_brand"]
      attachments[file_name] = File.read(zipfile_name)
      begin
        I18n.with_locale(I18n.locale) do
          mail(:to => options["recipient_email"], :subject => "subject")
        end    
      rescue Exception => e
        puts "+=======+++++++++++++++++++++++++++++++++++++#{e.message}"
      end  
      
      puts "=====send_archive_bills_via_email -- 4"
    end
    puts "=====send_archive_bills_via_email -- 5"
  end

  def send_invoice_to_accountant_via_email(options={})
    @message = options[:message]
    @current_brand = Brand.find_by_id options[:current_brand]
    @customer_bill = CustomerBill.find_by_id options[:customer_bill_id]
    @without_image = "false"
    invoice_pdf_name = t("send_bills.file_name_bill_archive_attachment",:name => @customer_bill.customer.b_name, :date => @customer_bill.invoice_date.strftime("%m/%Y"), :invoice_number => @customer_bill.invoice_number, :rate => @customer_bill.total_amount) 
    invoice_content = render_to_string(:layout => "pdf.html", :template => 'pdf/print_invoice.pdf.haml')
    attachments["#{invoice_pdf_name}.pdf"] = WickedPdf.new.pdf_from_string(
        invoice_content,  pdf: "#{t("send_bills.copy_of_invoice")}",
                                viewport_size: '1280x1024',
                                :margin => { :top => 10, :bottom => 3, :left => 10, :right => 10})
      
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