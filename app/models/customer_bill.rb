class CustomerBill < ActiveRecord::Base

  include HasResources
  
	enum transportation_mode: ['Private', 'Public']
  enum payment_mode: ['NONE', 'CHEQUE', 'BANK', 'CASH']

  has_many :customer_bill_products, dependent: :destroy, inverse_of: :customer_bill
  accepts_nested_attributes_for :customer_bill_products, allow_destroy: true

  # has_many :customer_bill_payments, -> { order("payment_date DESC") }, dependent: :destroy, inverse_of: :customer_bill
  # accepts_nested_attributes_for :customer_bill_payments, allow_destroy: true

	belongs_to :customer, inverse_of: :customer_bills
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  belongs_to :updater, class_name: "User", foreign_key: "updater_id"

  validates :customer, :presence => true
	validates :invoice_number, :presence => true
	validates :invoice_date, :presence => true

  def self.localize_months_values
    array = []
    months = []
    months = Date::MONTHNAMES.compact
    months.each_with_index do |name,idx|
      idx = idx+1
      display_name = I18n.t("activerecord.attributes.#{model_name.i18n_key}.months.#{name.downcase}", default: name.titleize)
      array << [display_name, idx]
    end
    array
  end
end
