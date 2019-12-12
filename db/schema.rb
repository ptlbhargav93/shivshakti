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

ActiveRecord::Schema.define(version: 20180102061224) do

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "creator_id",             limit: 4
    t.integer  "updater_id",             limit: 4
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "brands", force: :cascade do |t|
    t.string   "name",               limit: 100,                   null: false
    t.string   "slug",               limit: 100
    t.string   "custom_domain",      limit: 100
    t.string   "custom_domain_type", limit: 100
    t.string   "redirect_domain",    limit: 100
    t.string   "prefix",             limit: 10,                    null: false
    t.text     "description",        limit: 65535
    t.string   "phone_number",       limit: 50
    t.string   "email",              limit: 50
    t.string   "site_description",   limit: 255
    t.string   "site_keywords",      limit: 255
    t.string   "site_title",         limit: 255
    t.string   "country_code",       limit: 255
    t.string   "string",             limit: 255
    t.string   "currency_code",      limit: 255
    t.string   "currency_sign",      limit: 255
    t.boolean  "is_active",                        default: true,  null: false
    t.boolean  "is_deleted",                       default: false, null: false
    t.boolean  "is_chain",                         default: true,  null: false
    t.integer  "creator_id",         limit: 4
    t.integer  "updater_id",         limit: 4
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "logo_file_name",     limit: 255
    t.string   "logo_content_type",  limit: 255
    t.integer  "logo_file_size",     limit: 4
    t.datetime "logo_updated_at"
  end

  add_index "brands", ["name"], name: "index_brands_on_name", unique: true, using: :btree
  add_index "brands", ["prefix"], name: "index_brands_on_prefix", unique: true, using: :btree

  create_table "customer_bill_products", force: :cascade do |t|
    t.integer  "customer_bill_id",   limit: 4,   null: false
    t.string   "vehical_number",     limit: 255
    t.string   "ref_invoice_number", limit: 255, null: false
    t.string   "from",               limit: 255
    t.string   "to",                 limit: 255
    t.float    "quantity",           limit: 24
    t.float    "rate",               limit: 24
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "customer_bills", force: :cascade do |t|
    t.integer  "customer_id",    limit: 4,                 null: false
    t.string   "invoice_number", limit: 255,               null: false
    t.datetime "invoice_date",                             null: false
    t.string   "lr_number",      limit: 255,               null: false
    t.datetime "lr_date",                                  null: false
    t.float    "cgst",           limit: 24
    t.float    "sgst",           limit: 24
    t.float    "total_amount",   limit: 24,  default: 0.0
    t.integer  "creator_id",     limit: 4
    t.integer  "updater_id",     limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string   "name",         limit: 255,                 null: false
    t.string   "b_address",    limit: 255
    t.string   "b_city",       limit: 255
    t.string   "b_state",      limit: 255
    t.string   "b_state_code", limit: 255
    t.string   "b_pin_code",   limit: 255
    t.string   "b_country",    limit: 255
    t.string   "s_address",    limit: 255
    t.string   "s_city",       limit: 255
    t.string   "s_state",      limit: 255
    t.string   "s_state_code", limit: 255
    t.string   "s_pin_code",   limit: 255
    t.string   "s_country",    limit: 255
    t.boolean  "is_shipping",              default: false
    t.string   "gst_number",   limit: 255
    t.integer  "creator_id",   limit: 4
    t.integer  "updater_id",   limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "resource_specs", force: :cascade do |t|
    t.string   "name",       limit: 100,                 null: false
    t.boolean  "limited",                default: false, null: false
    t.boolean  "is_active",              default: true,  null: false
    t.boolean  "is_deleted",             default: false, null: false
    t.integer  "creator_id", limit: 4
    t.integer  "updater_id", limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "resource_specs", ["name"], name: "index_resource_specs_on_name", unique: true, using: :btree

  create_table "resource_types", force: :cascade do |t|
    t.string   "name",       limit: 100,                 null: false
    t.boolean  "is_active",              default: true,  null: false
    t.boolean  "is_deleted",             default: false, null: false
    t.integer  "creator_id", limit: 4
    t.integer  "updater_id", limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "resource_types", ["name"], name: "index_resource_types_on_name", unique: true, using: :btree

  create_table "resources", force: :cascade do |t|
    t.integer  "resource_holder_id",    limit: 4,                   null: false
    t.string   "resource_holder_type",  limit: 255,                 null: false
    t.integer  "resource_spec_id",      limit: 4,                   null: false
    t.integer  "resource_type_id",      limit: 4,                   null: false
    t.string   "media_attachment_name", limit: 255
    t.boolean  "limited",                           default: false, null: false
    t.boolean  "is_active",                         default: true,  null: false
    t.boolean  "is_deleted",                        default: false, null: false
    t.integer  "creator_id",            limit: 4
    t.integer  "updater_id",            limit: 4
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "media_file_name",       limit: 255
    t.string   "media_content_type",    limit: 255
    t.integer  "media_file_size",       limit: 4
    t.datetime "media_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.integer  "role",                   limit: 4,   default: 0,     null: false
    t.integer  "creator_id",             limit: 4
    t.integer  "updater_id",             limit: 4
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "first_name",             limit: 50,                  null: false
    t.string   "last_name",              limit: 50,                  null: false
    t.string   "token",                  limit: 255
    t.boolean  "registered",                         default: false, null: false
    t.boolean  "intermediate",                       default: false, null: false
    t.boolean  "is_active",                          default: true,  null: false
    t.boolean  "is_deleted",                         default: false, null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
