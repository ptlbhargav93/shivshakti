class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :creator_id
      t.integer :updater_id      
      t.string :name,              null: false
      t.string :person_name
      t.string :mobile_number1
      t.string :mobile_number2
      t.string :mobile_number3
      t.text :address
      t.integer :city_id
      t.integer :area_id
      t.string :gst_number
      t.timestamps null: false
    end
  end
end
