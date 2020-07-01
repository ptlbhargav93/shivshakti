class SendMonthlyBillJob < ActiveJob::Base
  queue_as :default

  def perform(options)
    Mailer.send_archive_bills_via_email(options).deliver_later
  end
end
