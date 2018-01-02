class CreateCustomerAccounts < ActiveRecord::Migration
  def change
    create_table :customer_accounts do |t|
	    t.integer :customer_id,  null: false
      t.integer :creator_id
      t.integer :updater_id
      t.float :debit_amount,  null: false
      t.string :debit_bill_number
      t.datetime :debit_bill_date,  null: false
      t.float :credit_amount
      t.string :credit_bill_number
      t.datetime :credit_bill_date
	    t.integer :credit_by_id
	    t.boolean :verified, null: false, default: true
      t.timestamps null: false
    end
  end
end
