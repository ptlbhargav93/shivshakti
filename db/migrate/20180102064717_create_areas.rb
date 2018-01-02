class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.integer :creator_id
      t.integer :updater_id
	    t.string :name, null: false
	    t.string :pincode
	    t.integer :city_id
      t.timestamps null: false
    end
  end
end