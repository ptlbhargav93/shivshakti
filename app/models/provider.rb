class Provider < ActiveRecord::Base
	
	belongs_to :city, inverse_of: :providers
	belongs_to :area, inverse_of: :providers
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"		

	validates :name, :presence => true	
end
