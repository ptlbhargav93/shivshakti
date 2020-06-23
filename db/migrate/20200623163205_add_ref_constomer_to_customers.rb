class AddRefConstomerToCustomers < ActiveRecord::Migration
  def change
  	add_column :customers, :ref_customer, :string
  	add_column :customer_bills, :payment_mode, :integer, default: 0, null: false
  	add_column :customer_bills, :payment_date, :date
  	add_column :customer_bills, :cheque_number, :string
  	add_column :customer_bills, :bank_name, :string
  end
end
