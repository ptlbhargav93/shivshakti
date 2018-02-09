class Provider < ActiveRecord::Base

	has_many :prodct_purchses, inverse_of: :provider
	
	belongs_to :city, inverse_of: :providers
	belongs_to :area, inverse_of: :providers

	has_many :income_expenses, inverse_of: :provider

    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"		

	validates :name, :presence => true
	validates :city, :presence => true
	validates :area, :presence => true
end
