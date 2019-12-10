class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name, null: false
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :state_code
      t.string :pin_code
      t.string :country
      t.string :email
      t.string :phone_number
      t.string :gst_number
      t.integer :creator_id
      t.integer :updater_id      
      t.timestamps null: false
    end
  end
end
