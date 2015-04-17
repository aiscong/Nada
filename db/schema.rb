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

ActiveRecord::Schema.define(version: 20150416222652) do

  create_table "bills", force: :cascade do |t|
    t.integer  "creditor_id"
    t.integer  "debtor_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.decimal  "amount",       default: 0.0
    t.boolean  "settled",      default: false
    t.datetime "settled_date"
  end

  add_index "bills", ["creditor_id"], name: "index_bills_on_creditor_id"
  add_index "bills", ["debtor_id"], name: "index_bills_on_debtor_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
