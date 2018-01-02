class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :creator_id
      t.integer :updater_id
      t.datetime :order_date,  null: false
      t.integer :customer_id,  null: false
      t.integer :product_id,  null: false
      t.integer :total_bags
      t.float :price_per_kg
      t.float :total_kg
      t.datetime :dispatched_date
      t.boolean :dispatched, null: false, default: false
      t.timestamps null: false
    end
  end
end
