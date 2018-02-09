class State < ActiveRecord::Base
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"	
    has_many :cities, inverse_of: :state

    validates :name, :presence => true, :length => {:maximum => 255}	
end
