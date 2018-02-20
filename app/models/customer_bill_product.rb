class CustomerBillProduct < ActiveRecord::Base
	enum bag_type: ['5', '10', '20', '25', '40', '50']
	belongs_to :product, inverse_of: :customer_bill_products
	belongs_to :customer_bill, inverse_of: :customer_bill_products

	validates :customer_bill_id, :presence => true	
	validates :product_id, :presence => true	
end
