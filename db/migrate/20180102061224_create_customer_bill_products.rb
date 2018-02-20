class CreateCustomerBillProducts < ActiveRecord::Migration
  def change
    create_table :customer_bill_products do |t|
      t.integer :customer_bill_id,  null: false
      t.integer :product_id,  null: false
      t.integer :bag_type, default: 3
      t.integer :bags, default: 0
      t.float :quantity, default: 0
      t.float :rate, default: 0
      t.timestamps null: false
    end
  end
end
