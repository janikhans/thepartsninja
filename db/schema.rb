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

ActiveRecord::Schema.define(version: 20170427064857) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ar_internal_metadata", primary_key: "key", id: :string, force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "brands", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.string   "website"
    t.string   "slug"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["slug"], name: "index_brands_on_slug", unique: true, using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",                        null: false
    t.string   "description"
    t.integer  "parent_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "ancestry"
    t.boolean  "leaf",        default: false
    t.index ["ancestry"], name: "index_categories_on_ancestry", using: :btree
    t.index ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  end

  create_table "check_searches", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "vehicle_id",            null: false
    t.integer  "comparing_vehicle_id",  null: false
    t.integer  "category_id"
    t.string   "category_name",         null: false
    t.integer  "results_count"
    t.integer  "fitment_note_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "search_type"
    t.integer  "max_score"
    t.integer  "grouped_count"
    t.integer  "above_threshold_count"
    t.index ["category_id"], name: "index_check_searches_on_category_id", using: :btree
    t.index ["comparing_vehicle_id"], name: "index_check_searches_on_comparing_vehicle_id", using: :btree
    t.index ["fitment_note_id"], name: "index_check_searches_on_fitment_note_id", using: :btree
    t.index ["user_id"], name: "index_check_searches_on_user_id", using: :btree
    t.index ["vehicle_id"], name: "index_check_searches_on_vehicle_id", using: :btree
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

  create_table "compatibility_searches", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "vehicle_id",            null: false
    t.integer  "category_id"
    t.string   "category_name",         null: false
    t.integer  "results_count"
    t.integer  "fitment_note_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "search_type"
    t.integer  "max_score"
    t.integer  "grouped_count"
    t.integer  "above_threshold_count"
    t.index ["category_id"], name: "index_compatibility_searches_on_category_id", using: :btree
    t.index ["fitment_note_id"], name: "index_compatibility_searches_on_fitment_note_id", using: :btree
    t.index ["user_id"], name: "index_compatibility_searches_on_user_id", using: :btree
    t.index ["vehicle_id"], name: "index_compatibility_searches_on_vehicle_id", using: :btree
  end

  create_table "discoveries", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_discoveries_on_user_id", using: :btree
  end

  create_table "ebay_categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "ancestry"
    t.index ["ancestry"], name: "index_ebay_categories_on_ancestry", using: :btree
    t.index ["parent_id"], name: "index_ebay_categories_on_parent_id", using: :btree
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

  create_table "forum_posts", force: :cascade do |t|
    t.integer  "forum_thread_id", null: false
    t.integer  "user_id",         null: false
    t.text     "body",            null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["forum_thread_id"], name: "index_forum_posts_on_forum_thread_id", using: :btree
    t.index ["user_id"], name: "index_forum_posts_on_user_id", using: :btree
  end

  create_table "forum_threads", force: :cascade do |t|
    t.integer  "forum_topic_id", null: false
    t.integer  "author_id",      null: false
    t.string   "subject",        null: false
    t.string   "slug"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["author_id"], name: "index_forum_threads_on_author_id", using: :btree
    t.index ["forum_topic_id"], name: "index_forum_threads_on_forum_topic_id", using: :btree
    t.index ["slug"], name: "index_forum_threads_on_slug", unique: true, using: :btree
  end

  create_table "forum_topics", force: :cascade do |t|
    t.string   "title",      null: false
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_forum_topics_on_slug", unique: true, using: :btree
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

  create_table "import_errors", force: :cascade do |t|
    t.string   "type",          null: false
    t.text     "row",           null: false
    t.text     "import_errors", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
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

  create_table "products", force: :cascade do |t|
    t.string   "name",             default: "", null: false
    t.text     "description"
    t.string   "slug"
    t.integer  "brand_id"
    t.integer  "user_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "ebay_category_id"
    t.integer  "category_id"
    t.index ["brand_id"], name: "index_products_on_brand_id", using: :btree
    t.index ["category_id"], name: "index_products_on_category_id", using: :btree
    t.index ["ebay_category_id"], name: "index_products_on_ebay_category_id", using: :btree
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

  add_foreign_key "check_searches", "categories"
  add_foreign_key "check_searches", "fitment_notes"
  add_foreign_key "check_searches", "users"
  add_foreign_key "check_searches", "vehicles"
  add_foreign_key "compatibility_searches", "categories"
  add_foreign_key "compatibility_searches", "fitment_notes"
  add_foreign_key "compatibility_searches", "users"
  add_foreign_key "compatibility_searches", "vehicles"
  add_foreign_key "fitment_notations", "fitment_notes"
  add_foreign_key "fitment_notations", "fitments"
  add_foreign_key "forum_posts", "forum_threads"
  add_foreign_key "forum_posts", "users"
  add_foreign_key "forum_threads", "forum_topics"
  add_foreign_key "products", "categories"
  add_foreign_key "vehicle_models", "brands"
  add_foreign_key "vehicle_models", "vehicle_types"
  add_foreign_key "vehicle_submodels", "vehicle_models"
  add_foreign_key "vehicles", "vehicle_submodels"
  add_foreign_key "vehicles", "vehicle_years"

  create_view :search_records,  sql_definition: <<-SQL
      SELECT row_number() OVER () AS id,
      t.searchable_id,
      t.searchable_type,
      t.search_type,
      t.user_id,
      t.vehicle_id,
      t.comparing_vehicle_id,
      t.category_id,
      t.category_name,
      t.fitment_note_id,
      t.results_count,
      t.grouped_count,
      t.max_score,
      t.above_threshold_count,
      t.created_at,
      t.updated_at
     FROM ( SELECT check_searches.id AS searchable_id,
              'CheckSearch'::text AS searchable_type,
              check_searches.search_type,
              check_searches.user_id,
              check_searches.vehicle_id,
              check_searches.comparing_vehicle_id,
              check_searches.category_id,
              check_searches.category_name,
              check_searches.fitment_note_id,
              check_searches.results_count,
              check_searches.grouped_count,
              NULL::integer AS max_score,
              NULL::integer AS above_threshold_count,
              check_searches.created_at,
              check_searches.updated_at
             FROM check_searches
          UNION
           SELECT compatibility_searches.id AS searchable_id,
              'CompatibilitySearch'::text AS searchable_type,
              compatibility_searches.search_type,
              compatibility_searches.user_id,
              compatibility_searches.vehicle_id,
              NULL::integer AS comparing_vehicle_id,
              compatibility_searches.category_id,
              compatibility_searches.category_name,
              compatibility_searches.fitment_note_id,
              compatibility_searches.results_count,
              compatibility_searches.grouped_count,
              compatibility_searches.max_score,
              compatibility_searches.above_threshold_count,
              compatibility_searches.created_at,
              compatibility_searches.updated_at
             FROM compatibility_searches
    ORDER BY 14) t;
  SQL

end
