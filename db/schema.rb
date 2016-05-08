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

ActiveRecord::Schema.define(version: 20160508175426) do

  create_table "brands", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.string   "website"
    t.string   "slug"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "brands", ["slug"], name: "index_brands_on_slug", unique: true

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id"

  create_table "compatibles", force: :cascade do |t|
    t.integer  "part_id"
    t.integer  "compatible_part_id"
    t.integer  "discovery_id"
    t.boolean  "backwards",          default: false, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "cached_votes_score", default: 0
  end

  add_index "compatibles", ["cached_votes_score"], name: "index_compatibles_on_cached_votes_score"
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

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "leads", force: :cascade do |t|
    t.string   "email",      null: false
    t.boolean  "auto"
    t.boolean  "streetbike"
    t.boolean  "dirtbike"
    t.boolean  "atv"
    t.boolean  "utv"
    t.boolean  "watercraft"
    t.boolean  "snowmobile"
    t.boolean  "dualsport"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "part_attributes", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "part_attributes", ["parent_id"], name: "index_part_attributes_on_parent_id"

  create_table "part_traits", force: :cascade do |t|
    t.integer  "Part_id",          null: false
    t.integer  "PartAttribute_id", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "part_traits", ["PartAttribute_id"], name: "index_part_traits_on_PartAttribute_id"
  add_index "part_traits", ["Part_id"], name: "index_part_traits_on_Part_id"

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
    t.string   "slug"
    t.integer  "brand_id"
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "category_id"
  end

  add_index "products", ["brand_id"], name: "index_products_on_brand_id"
  add_index "products", ["category_id"], name: "index_products_on_category_id"
  add_index "products", ["slug"], name: "index_products_on_slug", unique: true
  add_index "products", ["user_id"], name: "index_products_on_user_id"

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "location"
    t.text     "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id"

  create_table "searches", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "vehicle_id"
    t.string   "brand"
    t.string   "model"
    t.integer  "year"
    t.string   "part"
    t.integer  "compatibles", default: 0
    t.integer  "potentials",  default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id"
  add_index "searches", ["vehicle_id"], name: "index_searches_on_vehicle_id"

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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.string   "username",               default: "", null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "role",                   default: 0,  null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count"
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "vehicles", force: :cascade do |t|
    t.string   "model",      default: "", null: false
    t.integer  "year",                    null: false
    t.string   "slug"
    t.integer  "brand_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "vehicles", ["brand_id"], name: "index_vehicles_on_brand_id"
  add_index "vehicles", ["slug"], name: "index_vehicles_on_slug", unique: true

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
