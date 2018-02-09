class Customer < ActiveRecord::Base
	has_many :customer_accounts, inverse_of: :customer
	has_many :income_expenses, inverse_of: :customer
	belongs_to :city, inverse_of: :customers
	belongs_to :area, inverse_of: :customers
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"		

	validates :name, :presence => true
end
