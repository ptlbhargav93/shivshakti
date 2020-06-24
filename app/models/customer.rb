class Customer < ActiveRecord::Base
	has_many :customer_bills, inverse_of: :customer, dependent: :destroy
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"		

	validates :b_name, :presence => true
end
