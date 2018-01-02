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

  brand = Brand.find_or_create_by!(name: 'Madhav', prefix: 'madh', phone_number: '99999999', email: 'admin@madhavcorporation.in', :slug => 'madhav', :custom_domain => 'madhavcorporation.in')
  brand.logo = File.open("#{Rails.root}/app/assets/images/madhav-logo.png")

  brand.country_code = "IN" 
  brand.currency_code = "INR"
  brand.currency_sign = "₹"
  brand.save!



puts "\n> -- Seeds::Development::Brand::User  --------------------------"

  executive = brand.users.create!(email: 'murli@madhavcorporation.in', first_name: 'Murli', last_name: 'Barai', password: 'password', password_confirmation: 'password', registered: true)

  admin_user = AdminUser.find_by(email: 'admin@madhavcorporation.in')
  unless admin_user
    AdminUser.create!(email: 'admin@madhavcorporation.in', password: 'password', password_confirmation: 'password')
  end