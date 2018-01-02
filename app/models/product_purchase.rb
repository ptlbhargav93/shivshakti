class ProductPurchase < ActiveRecord::Base
	belongs_to :product, inverse_of: :prodct_purchses
	belongs_to :provider, inverse_of: :prodct_purchses
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"		

	validates :product_id, :presence => true	
	validates :provider_id, :presence => true	
	validates :purchase_date, :presence => true	
	validates :total_bag, :presence => true	
end
