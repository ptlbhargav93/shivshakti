class ChangeColumnName < ActiveRecord::Migration
  def change
  	rename_column :customers, :name, :b_name
  	rename_column :customers, :gst_number, :b_gst_number
  	add_column :customers, :s_name, :string
  	add_column :customers, :s_gst_number, :string
  end
end
