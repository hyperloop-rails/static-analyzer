# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you"ll amass, the slower it"ll run and the greater likelihood for issues).
#
# It"s strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_150_519_173_350) do
  create_table "nifty_key_value_store", force: true do |t|
    t.integer "parent_id"
    t.string  "parent_type"
    t.string  "group"
    t.string  "name"
    t.string  "value"
  end

  create_table "addresses", force: true do |t|
    t.integer  "customer_id"
    t.string   "address_type"
    t.boolean  "default"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "address4"
    t.string   "postcode"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ['customer_id'], name: 'index_addresses_on_customer_id'

  create_table "attachments", force: true do |t|
    t.integer  "parent_id",   null: false
    t.string   "parent_type", null: false
    t.string   "token"
    t.string   "file", null: false
    t.string   "file_name"
    t.integer  "file_size"
    t.string   "file_type"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string  "name"
    t.string  "code2"
    t.string  "code3"
    t.string  "continent"
    t.string  "tld"
    t.string  "currency"
    t.boolean "eu_member", default: false
  end

  create_table "customers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
    t.string   "email"
    t.string   "phone"
    t.string   "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delivery_service_prices", force: true do |t|
    t.integer  "delivery_service_id"
    t.string   "code"
    t.decimal  "price",               precision: 8, scale: 2
    t.decimal  "cost_price",          precision: 8, scale: 2
    t.integer  "tax_rate_id"
    t.decimal  "min_weight",          precision: 8, scale: 2
    t.decimal  "max_weight",          precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "country_ids"
  end

  add_index "delivery_service_prices", ['delivery_service_id'], name: 'index_delivery_service_prices_on_delivery_service_id'
  add_index "delivery_service_prices", ['max_weight'], name: 'index_delivery_service_prices_on_max_weight'
  add_index "delivery_service_prices", ['min_weight'], name: 'index_delivery_service_prices_on_min_weight'
  add_index "delivery_service_prices", ['price'], name: 'index_delivery_service_prices_on_price'

  create_table "delivery_services", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.boolean  "default",      default: false
    t.boolean  "active",       default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "courier"
    t.string   "tracking_url"
  end

  add_index "delivery_services", ['active'], name: 'index_delivery_services_on_active'

  create_table "order_items", force: true do |t|
    t.integer  "order_id"
    t.integer  "ordered_item_id"
    t.string   "ordered_item_type"
    t.integer  "quantity", default: 1
    t.decimal  "unit_price",        precision: 8, scale: 2
    t.decimal  "unit_cost_price",   precision: 8, scale: 2
    t.decimal  "tax_amount",        precision: 8, scale: 2
    t.decimal  "tax_rate",          precision: 8, scale: 2
    t.decimal  "weight",            precision: 8, scale: 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_items", ['order_id'], name: 'index_order_items_on_order_id'
  add_index "order_items", %w(ordered_item_id ordered_item_type), name: 'index_order_items_ordered_item'

  create_table "orders", force: true do |t|
    t.string   "token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
    t.string   "billing_address1"
    t.string   "billing_address2"
    t.string   "billing_address3"
    t.string   "billing_address4"
    t.string   "billing_postcode"
    t.integer  "billing_country_id"
    t.string   "email_address"
    t.string   "phone_number"
    t.string   "status"
    t.datetime "received_at"
    t.datetime "accepted_at"
    t.datetime "shipped_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delivery_service_id"
    t.decimal  "delivery_price",            precision: 8, scale: 2
    t.decimal  "delivery_cost_price",       precision: 8, scale: 2
    t.decimal  "delivery_tax_rate",         precision: 8, scale: 2
    t.decimal  "delivery_tax_amount",       precision: 8, scale: 2
    t.integer  "accepted_by"
    t.integer  "shipped_by"
    t.string   "consignment_number"
    t.datetime "rejected_at"
    t.integer  "rejected_by"
    t.string   "ip_address"
    t.text     "notes"
    t.boolean  "separate_delivery_address", default: false
    t.string   "delivery_name"
    t.string   "delivery_address1"
    t.string   "delivery_address2"
    t.string   "delivery_address3"
    t.string   "delivery_address4"
    t.string   "delivery_postcode"
    t.integer  "delivery_country_id"
    t.decimal  "amount_paid", precision: 8, scale: 2, default: 0.0
    t.boolean  "exported", default: false
    t.string   "invoice_number"
    t.integer  "customer_id"
  end

  add_index "orders", ['delivery_service_id'], name: 'index_orders_on_delivery_service_id'
  add_index "orders", ['received_at'], name: 'index_orders_on_received_at'
  add_index "orders", ['token'], name: 'index_orders_on_token'

  create_table "payments", force: true do |t|
    t.integer  "order_id"
    t.decimal  "amount", precision: 8, scale: 2, default: 0.0
    t.string   "reference"
    t.string   "method"
    t.boolean  "confirmed",                                 default: true
    t.boolean  "refundable",                                default: false
    t.decimal  "amount_refunded", precision: 8, scale: 2, default: 0.0
    t.integer  "parent_payment_id"
    t.boolean  "exported", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ['order_id'], name: 'index_payments_on_order_id'
  add_index "payments", ['parent_payment_id'], name: 'index_payments_on_parent_payment_id'

  create_table "product_attributes", force: true do |t|
    t.integer  "product_id"
    t.string   "key"
    t.string   "value"
    t.integer  "position",   default: 1
    t.boolean  "searchable", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public", default: true
  end

  add_index "product_attributes", ['key'], name: 'index_product_attributes_on_key'
  add_index "product_attributes", ['position'], name: 'index_product_attributes_on_position'
  add_index "product_attributes", ['product_id'], name: 'index_product_attributes_on_product_id'

  create_table "product_categories", force: true do |t|
    t.string   "name"
    t.string   "permalink"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "ancestral_permalink"
    t.boolean  "permalink_includes_ancestors", default: false
  end

  add_index "product_categories", ['lft'], name: 'index_product_categories_on_lft'
  add_index "product_categories", ['permalink'], name: 'index_product_categories_on_permalink'
  add_index "product_categories", ['rgt'], name: 'index_product_categories_on_rgt'

  create_table "product_categorizations", force: true do |t|
    t.integer "product_id",          null: false
    t.integer "product_category_id", null: false
  end

  add_index "product_categorizations", ['product_category_id'], name: 'categorization_by_product_category_id'
  add_index "product_categorizations", ['product_id'], name: 'categorization_by_product_id'

  create_table "product_category_translations", force: true do |t|
    t.integer  "product_category_id", null: false
    t.string   "locale",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "permalink"
    t.text     "description"
  end


  create_table "product_translations", force: true do |t|
    t.integer  "product_id", null: false
    t.string   "locale",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "permalink"
    t.text     "description"
    t.text     "short_description"
  end

  add_index "product_translations", ['locale'], name: 'index_product_translations_on_locale'
  add_index "product_translations", ['product_id'], name: 'index_product_translations_on_product_id'

  create_table "products", force: true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.string   "sku"
    t.string   "permalink"
    t.text     "description"
    t.text     "short_description"
    t.boolean  "active",                                    default: true
    t.decimal  "weight",            precision: 8, scale: 3, default: 0.0
    t.decimal  "price",             precision: 8, scale: 2, default: 0.0
    t.decimal  "cost_price",        precision: 8, scale: 2, default: 0.0
    t.integer  "tax_rate_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "featured", default: false
    t.text     "in_the_box"
    t.boolean  "stock_control",                             default: true
    t.boolean  "default",                                   default: false
  end

  add_index "products", ['parent_id'], name: 'index_products_on_parent_id'
  add_index "products", ['permalink'], name: 'index_products_on_permalink'
  add_index "products", ['sku'], name: 'index_products_on_sku'

  create_table "settings", force: true do |t|
    t.string "key"
    t.string "value"
    t.string "value_type"
  end

  add_index "settings", ['key'], name: 'index_settings_on_key'

  create_table "stock_level_adjustments", force: true do |t|
    t.integer  "item_id"
    t.string   "item_type"
    t.string   "description"
    t.integer  "adjustment", default: 0
    t.string   "parent_type"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end


  create_table "tax_rates", force: true do |t|
    t.string   "name"
    t.decimal  "rate", precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "country_ids"
    t.string   "address_type"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ['email_address'], name: 'index_users_on_email_address'
end
