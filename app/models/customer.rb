class Customer < ActiveRecord::Base
	belongs_to :brand, inverse_of: :customers
	belongs_to :city, inverse_of: :customers
	belongs_to :area, inverse_of: :customers
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"		

	validates :company_name, :presence => true
end
