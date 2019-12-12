class CreateCustomerBills < ActiveRecord::Migration
  def change
    create_table :customer_bills do |t|
	    t.integer :customer_id,  null: false
      t.string :invoice_number,  null: false
      t.datetime :invoice_date,  null: false
      t.string :lr_number,  null: false
      t.datetime :lr_date,  null: false
      t.float :cgst
      t.float :sgst
      t.float :total_amount, default: 0
      t.integer :creator_id
      t.integer :updater_id
      t.timestamps null: false
    end
  end
end
