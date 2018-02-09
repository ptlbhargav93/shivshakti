class Stock < ActiveRecord::Base
	
	belongs_to :product, inverse_of: :stocks
	
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"		

	validates :product, :presence => true	
	validates :stock_date, :presence => true	
end
