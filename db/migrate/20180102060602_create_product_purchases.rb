class CreateProductPurchases < ActiveRecord::Migration
  def change
    create_table :product_purchases do |t|
      t.integer :creator_id
      t.integer :updater_id    	
	    t.integer :product_id, null: false
	    t.integer :provider_id, null: false
	    t.datetime :purchase_date, null: false
	    t.integer :total_bag, null: false
	    t.float :kg_per_bag
	    t.float :amount_per_kg
      t.timestamps null: false
    end
  end
end
