class AddPoNumberToCustomerBills < ActiveRecord::Migration
  def change
    add_column :customer_bills, :po_number, :string
    add_column :customer_bills, :vendor_code, :string
  end
end
