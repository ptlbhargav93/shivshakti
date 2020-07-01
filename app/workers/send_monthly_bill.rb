class SendMonthlyBill
  include Sidekiq::Worker
  sidekiq_options retry: true

  def perform(options)
  	begin
  		Mailer.send_archive_bills_via_email(options).deliver_now
  	rescue Exception => e
  		puts "++++++++++++++++++++++++++++++++++++++++"
  		puts e.message
  		puts "========================================"
  	end
  end
end
