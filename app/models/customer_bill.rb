class CustomerBill < ActiveRecord::Base
	enum transportation_mode: ['Private', 'Public']

  has_many :customer_bill_products, dependent: :destroy, inverse_of: :customer_bill
  accepts_nested_attributes_for :customer_bill_products, allow_destroy: true

  has_many :customer_bill_payments, -> { order("payment_date DESC") }, dependent: :destroy, inverse_of: :customer_bill
  accepts_nested_attributes_for :customer_bill_payments, allow_destroy: true

	belongs_to :customer, inverse_of: :customer_bills
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  belongs_to :updater, class_name: "User", foreign_key: "updater_id"

  validates :customer, :presence => true
	validates :bill_number, :presence => true
	validates :bill_date, :presence => true
end
