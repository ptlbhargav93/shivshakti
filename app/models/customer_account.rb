class CustomerAccount < ActiveRecord::Base
	belongs_to :customer, inverse_of: :customer_accounts
	belongs_to :credit_by, class_name: "User", foreign_key: "credit_by_id"
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"		

	validates :debit_amount, :presence => true	
	validates :debit_bill_date, :presence => true	
end
