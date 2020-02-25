# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_07_123128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "dishes", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "note", limit: 1000
    t.integer "difficulty_level", default: 0, null: false
    t.integer "cooking_time", null: false
    t.integer "number_of_people", null: false
    t.integer "ready_weight", null: false
    t.decimal "kcal_per_100_grams", null: false
    t.decimal "protein_per_100_grams", null: false
    t.decimal "fat_per_100_grams", null: false
    t.decimal "carbohydrate_per_100_grams", null: false
    t.jsonb "recipe", null: false
    t.boolean "paid", null: false
    t.boolean "popular", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cooking_time"], name: "index_dishes_on_cooking_time"
    t.index ["difficulty_level"], name: "index_dishes_on_difficulty_level"
    t.index ["number_of_people"], name: "index_dishes_on_number_of_people"
    t.index ["paid"], name: "index_dishes_on_paid"
    t.index ["ready_weight"], name: "index_dishes_on_ready_weight"
  end

  create_table "dishes_category_codes", force: :cascade do |t|
    t.bigint "dish_id", null: false
    t.integer "category_code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dish_id", "category_code"], name: "index_dishes_category_codes_on_dish_id_and_category_code", unique: true
    t.index ["dish_id"], name: "index_dishes_category_codes_on_dish_id"
  end

  create_table "dishes_ingredients", force: :cascade do |t|
    t.bigint "dish_id", null: false
    t.bigint "ingredient_id", null: false
    t.integer "rank", default: 1, null: false
    t.decimal "quantity", default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dish_id", "ingredient_id"], name: "index_dishes_ingredients_on_dish_id_and_ingredient_id", unique: true
    t.index ["dish_id", "rank"], name: "index_dishes_ingredients_on_dish_id_and_rank", unique: true
    t.index ["dish_id"], name: "index_dishes_ingredients_on_dish_id"
    t.index ["ingredient_id"], name: "index_dishes_ingredients_on_ingredient_id"
  end

  create_table "dishes_preference_codes", force: :cascade do |t|
    t.bigint "dish_id", null: false
    t.integer "preference_code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dish_id", "preference_code"], name: "index_dishes_preference_codes_on_dish_id_and_preference_code", unique: true
    t.index ["dish_id"], name: "index_dishes_preference_codes_on_dish_id"
  end

  create_table "dishes_tags", force: :cascade do |t|
    t.bigint "dish_id", null: false
    t.string "tag", limit: 32, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dish_id", "tag"], name: "index_dishes_tags_on_dish_id_and_tag", unique: true
    t.index ["dish_id"], name: "index_dishes_tags_on_dish_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "measurement_unit", limit: 100, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "measurement_unit"], name: "index_ingredients_on_name_and_measurement_unit", unique: true
  end

  create_table "server_errors", force: :cascade do |t|
    t.text "message"
    t.text "backtrace"
    t.jsonb "extra"
    t.string "request_token"
    t.string "request_remote_ip"
    t.string "request_method"
    t.string "request_original_url"
    t.string "request_params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "key", null: false
    t.jsonb "value"
    t.string "datatype", limit: 16, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_settings_on_key", unique: true
    t.index ["value"], name: "index_settings_on_value"
  end

  create_table "user_action_tokens", force: :cascade do |t|
    t.string "token", limit: 256, null: false
    t.string "type_code", limit: 64, null: false
    t.bigint "user_id", null: false
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_action_tokens_on_user_id"
  end

  create_table "user_tokens", id: false, force: :cascade do |t|
    t.string "token", null: false
    t.bigint "user_id"
    t.string "http_remote_addr", null: false
    t.string "http_user_agent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token", "user_id"], name: "index_user_tokens_on_token_and_user_id"
    t.index ["token"], name: "index_user_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_user_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "login", limit: 48, null: false
    t.string "email", limit: 48
    t.string "phone", limit: 48
    t.string "password_digest", limit: 1024, null: false
    t.string "first_name", limit: 48
    t.string "last_name", limit: 48
    t.string "status_code", limit: 64, null: false
    t.string "role_code", limit: 64, null: false
    t.integer "auth_attempts", default: 0, null: false
    t.datetime "auth_blocked_until"
    t.datetime "password_updated_at"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["login"], name: "index_users_on_login", unique: true
    t.index ["phone"], name: "index_users_on_phone"
    t.index ["role_code"], name: "index_users_on_role_code"
    t.index ["status_code"], name: "index_users_on_status_code"
  end

  add_foreign_key "user_action_tokens", "users"
  add_foreign_key "user_tokens", "users"
end
