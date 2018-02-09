class Area < ActiveRecord::Base
	has_many :customers, inverse_of: :area
	has_many :providers, inverse_of: :area
	belongs_to :city, inverse_of: :areas
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"	

    validates :name, :presence => true, :length => {:maximum => 255}
    validates :city, :presence => true
end
