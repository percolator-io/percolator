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

ActiveRecord::Schema.define(version: 20140202195252) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "keywords",   default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
  end

  create_table "category_hierarchies", id: false, force: true do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "category_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "tag_anc_desc_udx", unique: true, using: :btree
  add_index "category_hierarchies", ["descendant_id"], name: "tag_desc_idx", using: :btree

  create_table "user_github_accounts", force: true do |t|
    t.integer  "user_id"
    t.string   "uid"
    t.text     "auth_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_github_accounts", ["uid"], name: "index_user_github_accounts_on_uid", using: :btree
  add_index "user_github_accounts", ["user_id"], name: "index_user_github_accounts_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_token"
  end

  add_index "users", ["api_token"], name: "index_users_on_api_token", unique: true, using: :btree

end
