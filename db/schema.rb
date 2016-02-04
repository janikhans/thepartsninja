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

ActiveRecord::Schema.define(version: 20160204210307) do

  create_table "brands", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.string   "website"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "compatibles", force: :cascade do |t|
    t.integer  "part_id"
    t.integer  "compatible_part_id"
    t.integer  "discovery_id"
    t.boolean  "backwards",          default: false, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "compatibles", ["compatible_part_id"], name: "index_compatibles_on_compatible_part_id"
  add_index "compatibles", ["discovery_id"], name: "index_compatibles_on_discovery_id"
  add_index "compatibles", ["part_id"], name: "index_compatibles_on_part_id"

  create_table "discoveries", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "comment"
    t.boolean  "modifications", default: false, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "discoveries", ["user_id"], name: "index_discoveries_on_user_id"

  create_table "fitments", force: :cascade do |t|
    t.integer  "part_id"
    t.integer  "vehicle_id"
    t.integer  "discovery_id"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "fitments", ["discovery_id"], name: "index_fitments_on_discovery_id"
  add_index "fitments", ["part_id", "vehicle_id"], name: "index_fitments_on_part_id_and_vehicle_id", unique: true
  add_index "fitments", ["part_id"], name: "index_fitments_on_part_id"
  add_index "fitments", ["user_id"], name: "index_fitments_on_user_id"
  add_index "fitments", ["vehicle_id"], name: "index_fitments_on_vehicle_id"

  create_table "parts", force: :cascade do |t|
    t.string   "part_number"
    t.text     "note"
    t.integer  "product_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "parts", ["product_id"], name: "index_parts_on_product_id"
  add_index "parts", ["user_id"], name: "index_parts_on_user_id"

  create_table "products", force: :cascade do |t|
    t.string   "name",        default: "", null: false
    t.text     "description"
    t.integer  "brand_id"
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "products", ["brand_id"], name: "index_products_on_brand_id"
  add_index "products", ["user_id"], name: "index_products_on_user_id"

  create_table "steps", force: :cascade do |t|
    t.text     "content",      default: "", null: false
    t.integer  "discovery_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "steps", ["discovery_id"], name: "index_steps_on_discovery_id"

  create_table "users", force: :cascade do |t|
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
    t.string   "username",               default: "", null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "role",                   default: 0,  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "vehicles", force: :cascade do |t|
    t.string   "model",      default: "", null: false
    t.integer  "year",                    null: false
    t.integer  "brand_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "vehicles", ["brand_id"], name: "index_vehicles_on_brand_id"

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"

end
