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

ActiveRecord::Schema.define(version: 20120427172031) do

  create_table "forum_threads", force: :cascade do |t|
    t.integer  "forum_id",                   null: false
    t.string   "title",                      null: false
    t.datetime "last_posted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "views",          default: 0, null: false
    t.integer  "posts_count",    default: 0, null: false
  end

  create_table "forums", force: :cascade do |t|
    t.integer  "site_id",                null: false
    t.string   "title",      limit: 100, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id",                          null: false
    t.integer  "forum_thread_id",                  null: false
    t.integer  "post_number",                      null: false
    t.text     "raw",                              null: false
    t.text     "cooked",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reply_to_post_number"
    t.integer  "cached_version",       default: 1, null: false
  end

  add_index "posts", ["forum_thread_id", "post_number"], name: "index_posts_on_forum_thread_id_and_post_number"
  add_index "posts", ["reply_to_post_number"], name: "index_posts_on_reply_to_post_number"
  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "schema_migration_details", force: :cascade do |t|
    t.string   "version",       null: false
    t.string   "name"
    t.string   "hostname"
    t.string   "git_version"
    t.string   "rails_version"
    t.integer  "duration"
    t.string   "direction"
    t.datetime "created_at",    null: false
  end

  add_index "schema_migration_details", ["version"], name: "index_schema_migration_details_on_version"

  create_table "sites", force: :cascade do |t|
    t.string   "title",      limit: 100, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",         limit: 20, null: false
    t.string   "avatar_url",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_username"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true

  create_table "versions", force: :cascade do |t|
    t.integer  "versioned_id"
    t.string   "versioned_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "user_name"
    t.text     "modifications"
    t.integer  "number"
    t.integer  "reverted_from"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "versions", ["created_at"], name: "index_versions_on_created_at"
  add_index "versions", ["number"], name: "index_versions_on_number"
  add_index "versions", ["tag"], name: "index_versions_on_tag"
  add_index "versions", ["user_id", "user_type"], name: "index_versions_on_user_id_and_user_type"
  add_index "versions", ["user_name"], name: "index_versions_on_user_name"
  add_index "versions", ["versioned_id", "versioned_type"], name: "index_versions_on_versioned_id_and_versioned_type"

end
