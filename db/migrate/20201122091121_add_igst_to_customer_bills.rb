class AddIgstToCustomerBills < ActiveRecord::Migration
  def change
    add_column :customer_bills, :igst, :float
  end
end
