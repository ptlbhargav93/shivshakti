class City < ActiveRecord::Base
	has_many :areas, inverse_of: :city
	has_many :customers, inverse_of: :city
	has_many :providers, inverse_of: :city
	belongs_to :state, inverse_of: :cities
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"		

    validates :name, :presence => true, :length => {:maximum => 255}
    validates :state, :presence => true
end
