class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.integer :creator_id
      t.integer :updater_id
      t.integer :product_id, null: false
      t.datetime :stock_date, null: false
      t.integer :open_stock
      t.integer :stock_in
      t.integer :stock_out
      t.integer :close_stock

      t.timestamps null: false
    end
  end
end
