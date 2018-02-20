class CreateCustomerBills < ActiveRecord::Migration
  def change
    create_table :customer_bills do |t|
      t.string :bill_number,  null: false
      t.datetime :bill_date,  null: false
      t.string :reverse_charge
      t.integer :state_id
      t.integer :transportation_mode, default: 0
      t.string :vehical_number
      t.datetime :date_of_supply
      t.string :place_of_supply
	    t.integer :customer_id,  null: false
      t.float :cgst, default: 0.0
      t.float :sgst, default: 0.0
      t.float :igst, default: 0.0
      t.float :total_amount, default: 0
	    t.boolean :verified, null: false, default: true
      t.integer :creator_id
      t.integer :updater_id
      t.timestamps null: false
    end
  end
end
