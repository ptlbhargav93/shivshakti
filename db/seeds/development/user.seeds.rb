# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'seedbank'
require 'ffaker'



puts "\n> -- Seeds::Development::Brand --------------------------"

  brand = Brand.find_or_create_by!(name: 'Shivshakti', prefix: 'shiv', phone_number: '99999999', email: 'admin@shivshakti.in', :slug => 'shivshakti')
  brand.logo = File.open("#{Rails.root}/app/assets/images/madhav-logo.png")

  brand.country_code = "IN" 
  brand.currency_code = "INR"
  brand.currency_sign = "₹"
  brand.save!



puts "\n> -- Seeds::Development::Brand::User  --------------------------"

  executive = User.create!(email: 'maulik@shivshakti.in', first_name: 'Maulik', last_name: 'Patel', password: 'password', password_confirmation: 'password', registered: true) unless User.find_by_email("maulik@shivshakti.in")
  executive = User.create!(email: 'rajan@shivshakti.in', first_name: 'Rajan', last_name: 'Patel', password: 'password', password_confirmation: 'password', registered: true) unless User.find_by_email("rajan@shivshakti.in")
  customer = Customer.create!(b_name: "GREENERA ENGINEERING LLP", b_address: "B/12 SITABA ESTATE NR ANUP ESTATE AMRAIWADI", b_city: "AHMEDABAD", b_state:"GUJARAT",b_state_code: "24", b_pin_code: "380026", b_country: "INDIA", b_gst_number: "24AATFG4315K1Z6", creator: executive)

  admin_user = AdminUser.find_by(email: 'admin@shivshakti.in')
  unless admin_user
    AdminUser.create!(email: 'admin@shivshakti.in', password: 'password', password_confirmation: 'password')
  end