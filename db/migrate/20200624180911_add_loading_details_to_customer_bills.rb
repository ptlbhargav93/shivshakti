class AddLoadingDetailsToCustomerBills < ActiveRecord::Migration
  def change
  	add_column :customer_bills, :loading_text, :string
  	add_column :customer_bills, :loading_amount, :float
  end
end
