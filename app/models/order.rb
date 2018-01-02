class Order < ActiveRecord::Base
	belongs_to :product, inverse_of: :orders
	belongs_to :customer, inverse_of: :orders
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"		

	validates :order_date, :presence => true	
	validates :customer_id, :presence => true	
	validates :product_id, :presence => true	
end
