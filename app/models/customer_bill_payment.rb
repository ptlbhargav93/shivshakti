class CustomerBillProduct < ActiveRecord::Base
	belongs_to :customer_bill, inverse_of: :customer_bill_products

	validates :customer_bill_id, :presence => true	
	validates :amount, :presence => true
end
