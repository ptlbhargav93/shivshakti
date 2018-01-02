class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.integer :creator_id
      t.integer :updater_id
	  t.string :name, null: false
	  t.integer :state_id
      t.timestamps null: false
    end
  end
end
