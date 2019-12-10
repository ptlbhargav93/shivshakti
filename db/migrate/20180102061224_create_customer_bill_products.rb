class CreateCustomerBillProducts < ActiveRecord::Migration
  def change
    create_table :customer_bill_products do |t|
      t.integer :customer_bill_id,  null: false
      t.string :vehical_number
      t.string :ref_invoice_number,  null: false
      t.string :from
      t.string :to
      t.float :quantity, default: 0
      t.float :rate, default: 0
      t.timestamps null: false
    end
  end
end
