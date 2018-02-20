class CustomerBillPayments < ActiveRecord::Migration
  def change
    create_table :customer_bill_payments do |t|
      t.integer :customer_bill_id,  null: false
      t.integer :amount, default: 0
      t.datetime :payment_date
      t.timestamps null: false
    end
  end
end
