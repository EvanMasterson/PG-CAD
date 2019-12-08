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

ActiveRecord::Schema.define(version: 20191201120530) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "storages", force: :cascade do |t|
    t.integer  "size"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_storages_on_user_id", using: :btree
  end

  create_table "uploaded_files", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.integer  "size",       default: 0,  null: false
    t.string   "unique_url", default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "storage_id"
    t.string   "image"
    t.string   "share_id"
    t.index ["storage_id"], name: "index_uploaded_files_on_storage_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
    t.integer  "selected_package"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "storages", "users"
  add_foreign_key "uploaded_files", "storages"
end
