class Area < ActiveRecord::Base
	belongs_to :city, inverse_of: :areas
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"	

    validates :name, :presence => true, :length => {:maximum => 255}
end
