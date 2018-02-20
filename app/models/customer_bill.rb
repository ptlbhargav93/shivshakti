class CustomerBill < ActiveRecord::Base
	enum transportation_mode: ['Private', 'Public']

	has_many :customer_bill_products, inverse_of: :customer_bills
	has_many :customer_bill_payments, inverse_of: :customer_bills

	belongs_to :customer, inverse_of: :customer_bills
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"

    validates :customer, :presence => true
	validates :bill_number, :presence => true
	validates :bill_date, :presence => true
end
