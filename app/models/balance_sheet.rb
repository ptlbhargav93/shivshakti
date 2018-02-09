class BalanceSheet < ActiveRecord::Base
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"	
    
	validates :account_date, :presence => true
	validates :open_balance, :presence => true
end
