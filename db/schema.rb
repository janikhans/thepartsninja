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

ActiveRecord::Schema.define(version: 20161023184017) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.string   "website"
    t.string   "slug"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["slug"], name: "index_brands_on_slug", unique: true, using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  end

  create_table "compatibilities", force: :cascade do |t|
    t.integer  "part_id"
    t.integer  "compatible_part_id"
    t.integer  "discovery_id"
    t.boolean  "backwards",          default: false, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "cached_votes_score", default: 0
    t.boolean  "modifications",      default: false, null: false
    t.index ["cached_votes_score"], name: "index_compatibilities_on_cached_votes_score", using: :btree
    t.index ["compatible_part_id"], name: "index_compatibilities_on_compatible_part_id", using: :btree
    t.index ["discovery_id"], name: "index_compatibilities_on_discovery_id", using: :btree
    t.index ["part_id"], name: "index_compatibilities_on_part_id", using: :btree
  end

  create_table "discoveries", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_discoveries_on_user_id", using: :btree
  end

  create_table "fitment_notations", force: :cascade do |t|
    t.integer  "fitment_id",      null: false
    t.integer  "fitment_note_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["fitment_id", "fitment_note_id"], name: "index_fitment_notations_on_fitment_id_and_fitment_note_id", unique: true, using: :btree
    t.index ["fitment_id"], name: "index_fitment_notations_on_fitment_id", using: :btree
    t.index ["fitment_note_id"], name: "index_fitment_notations_on_fitment_note_id", using: :btree
  end

  create_table "fitment_notes", force: :cascade do |t|
    t.string   "name",                            null: false
    t.integer  "parent_id"
    t.boolean  "used_for_search", default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["parent_id"], name: "index_fitment_notes_on_parent_id", using: :btree
  end

  create_table "fitments", force: :cascade do |t|
    t.integer  "part_id"
    t.integer  "vehicle_id"
    t.integer  "discovery_id"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "source"
    t.text     "note"
    t.index ["discovery_id"], name: "index_fitments_on_discovery_id", using: :btree
    t.index ["part_id", "vehicle_id"], name: "index_fitments_on_part_id_and_vehicle_id", unique: true, using: :btree
    t.index ["part_id"], name: "index_fitments_on_part_id", using: :btree
    t.index ["user_id"], name: "index_fitments_on_user_id", using: :btree
    t.index ["vehicle_id"], name: "index_fitments_on_vehicle_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

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
    t.index ["parent_id"], name: "index_part_attributes_on_parent_id", using: :btree
  end

  create_table "part_attributions", force: :cascade do |t|
    t.integer  "part_id",           null: false
    t.integer  "part_attribute_id", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["part_attribute_id"], name: "index_part_attributions_on_part_attribute_id", using: :btree
    t.index ["part_id"], name: "index_part_attributions_on_part_id", using: :btree
  end

  create_table "parts", force: :cascade do |t|
    t.string   "part_number"
    t.text     "note"
    t.integer  "product_id"
    t.integer  "user_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "epid"
    t.boolean  "ebay_fitments_imported",   default: false
    t.datetime "ebay_fitments_updated_at"
    t.index ["product_id"], name: "index_parts_on_product_id", using: :btree
    t.index ["user_id"], name: "index_parts_on_user_id", using: :btree
  end

  create_table "product_types", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "name",        null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_product_types_on_category_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "name",            default: "", null: false
    t.text     "description"
    t.string   "slug"
    t.integer  "brand_id"
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "category_id"
    t.integer  "product_type_id"
    t.index ["brand_id"], name: "index_products_on_brand_id", using: :btree
    t.index ["category_id"], name: "index_products_on_category_id", using: :btree
    t.index ["product_type_id"], name: "index_products_on_product_type_id", using: :btree
    t.index ["slug"], name: "index_products_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_products_on_user_id", using: :btree
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "location"
    t.text     "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id", using: :btree
  end

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
    t.index ["user_id"], name: "index_searches_on_user_id", using: :btree
    t.index ["vehicle_id"], name: "index_searches_on_vehicle_id", using: :btree
  end

  create_table "steps", force: :cascade do |t|
    t.text     "content",      default: "", null: false
    t.integer  "discovery_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["discovery_id"], name: "index_steps_on_discovery_id", using: :btree
  end

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
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "vehicle_models", force: :cascade do |t|
    t.integer  "brand_id"
    t.integer  "vehicle_type_id"
    t.string   "name",            null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["brand_id"], name: "index_vehicle_models_on_brand_id", using: :btree
    t.index ["vehicle_type_id"], name: "index_vehicle_models_on_vehicle_type_id", using: :btree
  end

  create_table "vehicle_submodels", force: :cascade do |t|
    t.integer  "vehicle_model_id"
    t.string   "name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["vehicle_model_id"], name: "index_vehicle_submodels_on_vehicle_model_id", using: :btree
  end

  create_table "vehicle_types", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicle_years", force: :cascade do |t|
    t.integer  "year",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string   "slug"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "vehicle_year_id"
    t.integer  "vehicle_submodel_id"
    t.integer  "epid"
    t.index ["slug"], name: "index_vehicles_on_slug", unique: true, using: :btree
    t.index ["vehicle_submodel_id"], name: "index_vehicles_on_vehicle_submodel_id", using: :btree
    t.index ["vehicle_year_id"], name: "index_vehicles_on_vehicle_year_id", using: :btree
  end

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
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree
  end

  add_foreign_key "fitment_notations", "fitment_notes"
  add_foreign_key "fitment_notations", "fitments"
  add_foreign_key "product_types", "categories"
  add_foreign_key "products", "product_types"
  add_foreign_key "vehicle_models", "brands"
  add_foreign_key "vehicle_models", "vehicle_types"
  add_foreign_key "vehicle_submodels", "vehicle_models"
  add_foreign_key "vehicles", "vehicle_submodels"
  add_foreign_key "vehicles", "vehicle_years"
end
