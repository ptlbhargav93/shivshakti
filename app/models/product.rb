class Product < ActiveRecord::Base
	enum product_type: ['PEANUTS', 'DAL']

    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"		

	validates :name, :presence => true	
end
