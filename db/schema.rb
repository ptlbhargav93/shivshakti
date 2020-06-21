# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200620092205) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "brands", force: :cascade do |t|
    t.string   "name",               limit: 100,                 null: false
    t.string   "slug",               limit: 100
    t.string   "custom_domain",      limit: 100
    t.string   "custom_domain_type", limit: 100
    t.string   "redirect_domain",    limit: 100
    t.string   "prefix",             limit: 10,                  null: false
    t.text     "description"
    t.string   "phone_number",       limit: 50
    t.string   "email",              limit: 50
    t.string   "site_description"
    t.string   "site_keywords"
    t.string   "site_title"
    t.string   "country_code"
    t.string   "string"
    t.string   "currency_code"
    t.string   "currency_sign"
    t.boolean  "is_active",                      default: true,  null: false
    t.boolean  "is_deleted",                     default: false, null: false
    t.boolean  "is_chain",                       default: true,  null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  add_index "brands", ["name"], name: "index_brands_on_name", unique: true, using: :btree
  add_index "brands", ["prefix"], name: "index_brands_on_prefix", unique: true, using: :btree

  create_table "customer_bill_products", force: :cascade do |t|
    t.integer  "customer_bill_id",   null: false
    t.string   "vehical_number"
    t.string   "ref_invoice_number", null: false
    t.string   "from"
    t.string   "to"
    t.float    "quantity"
    t.float    "rate"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "customer_bills", force: :cascade do |t|
    t.integer  "customer_id",                  null: false
    t.string   "invoice_number",               null: false
    t.datetime "invoice_date",                 null: false
    t.string   "lr_number",                    null: false
    t.datetime "lr_date",                      null: false
    t.float    "cgst"
    t.float    "sgst"
    t.float    "total_amount",   default: 0.0
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "po_number"
    t.string   "vendor_code"
  end

  create_table "customers", force: :cascade do |t|
    t.string   "b_name",                       null: false
    t.string   "b_address"
    t.string   "b_city"
    t.string   "b_state"
    t.string   "b_state_code"
    t.string   "b_pin_code"
    t.string   "b_country"
    t.string   "s_address"
    t.string   "s_city"
    t.string   "s_state"
    t.string   "s_state_code"
    t.string   "s_pin_code"
    t.string   "s_country"
    t.boolean  "is_shipping",  default: false
    t.string   "b_gst_number"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "s_name"
    t.string   "s_gst_number"
  end

  create_table "resource_specs", force: :cascade do |t|
    t.string   "name",       limit: 100,                 null: false
    t.boolean  "limited",                default: false, null: false
    t.boolean  "is_active",              default: true,  null: false
    t.boolean  "is_deleted",             default: false, null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "resource_specs", ["name"], name: "index_resource_specs_on_name", unique: true, using: :btree

  create_table "resource_types", force: :cascade do |t|
    t.string   "name",       limit: 100,                 null: false
    t.boolean  "is_active",              default: true,  null: false
    t.boolean  "is_deleted",             default: false, null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "resource_types", ["name"], name: "index_resource_types_on_name", unique: true, using: :btree

  create_table "resources", force: :cascade do |t|
    t.integer  "resource_holder_id",                    null: false
    t.string   "resource_holder_type",                  null: false
    t.integer  "resource_spec_id",                      null: false
    t.integer  "resource_type_id",                      null: false
    t.string   "media_attachment_name"
    t.boolean  "limited",               default: false, null: false
    t.boolean  "is_active",             default: true,  null: false
    t.boolean  "is_deleted",            default: false, null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "media_file_name"
    t.string   "media_content_type"
    t.integer  "media_file_size"
    t.datetime "media_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.integer  "role",                              default: 0,     null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name",             limit: 50,                 null: false
    t.string   "last_name",              limit: 50,                 null: false
    t.string   "token"
    t.boolean  "registered",                        default: false, null: false
    t.boolean  "intermediate",                      default: false, null: false
    t.boolean  "is_active",                         default: true,  null: false
    t.boolean  "is_deleted",                        default: false, null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
