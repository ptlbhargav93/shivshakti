class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string  :name, null: false
      t.string  :b_address
      t.string  :b_city
      t.string  :b_state
      t.string  :b_state_code
      t.string  :b_pin_code
      t.string  :b_country
      t.string  :s_address
      t.string  :s_city
      t.string  :s_state
      t.string  :s_state_code
      t.string  :s_pin_code
      t.string  :s_country
      t.boolean :is_shipping, default: false
      t.string  :gst_number
      t.integer :creator_id
      t.integer :updater_id      
      t.timestamps null: false
    end
  end
end
