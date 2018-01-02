class CreateIncomeExpenses < ActiveRecord::Migration
  def change
    create_table :income_expenses do |t|
      t.integer :creator_id
      t.integer :updater_id
      t.integer :amount_type, :default => 0, null: false
      t.datetime :amount_date,  null: false
      t.float :amount,  null: false
      t.integer :customer_id
      t.integer :user_id
      t.integer :provider_id
      t.text :detail
      t.timestamps null: false
    end
  end
end
