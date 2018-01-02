class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :creator_id
      t.integer :updater_id    	
	  t.string :name,  null: false
	  t.integer :product_type, :default => 0, null: false
	  t.integer :kilogram
      t.timestamps null: false
    end
  end
end
