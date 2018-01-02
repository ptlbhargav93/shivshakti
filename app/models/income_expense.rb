class IncomeExpense < ActiveRecord::Base
	enum amount_type: ['INCOME', 'EXPENSE']
	belongs_to :customer, inverse_of: :income_expenses
	belongs_to :user, inverse_of: :income_expenses
	belongs_to :provider, inverse_of: :income_expenses
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"		

    validates :amount_date, :presence => true
    validates :amount, :presence => true
end
