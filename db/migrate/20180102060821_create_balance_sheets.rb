class CreateBalanceSheets < ActiveRecord::Migration
  def change
    create_table :balance_sheets do |t|
      t.integer :creator_id
      t.integer :updater_id
      t.datetime :account_date,  null: false
      t.float :open_balance,  null: false
      t.float :income_balance
      t.float :expense_balance
      t.float :close_balance

      t.timestamps null: false
    end
  end
end
