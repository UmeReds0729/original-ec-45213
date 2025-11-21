# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_11_20_145625) do
  create_table "active_admin_comments", charset: "utf8mb3", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "ai_requests", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "input_text", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "people"
    t.index ["user_id"], name: "index_ai_requests_on_user_id"
  end

  create_table "chat_threads", charset: "utf8mb3", force: :cascade do |t|
    t.text "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "context"
  end

  create_table "favorite_menus", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "menu_id", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_favorite_menus_on_menu_id"
    t.index ["user_id"], name: "index_favorite_menus_on_user_id"
  end

  create_table "ingredients", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menu_ingredients", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "menu_id", null: false
    t.bigint "ingredient_id", null: false
    t.integer "quantity"
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_menu_ingredients_on_ingredient_id"
    t.index ["menu_id"], name: "index_menu_ingredients_on_menu_id"
  end

  create_table "menus", charset: "utf8mb3", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "people"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "ai_request_id", null: false
    t.index ["ai_request_id"], name: "index_menus_on_ai_request_id"
    t.index ["user_id"], name: "index_menus_on_user_id"
  end

  create_table "messages", charset: "utf8mb3", force: :cascade do |t|
    t.text "prompt"
    t.text "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "chat_thread_id", null: false
    t.index ["chat_thread_id"], name: "index_messages_on_chat_thread_id"
  end

  create_table "products", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "supermarket_prices", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "supermarket_id", null: false
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id", null: false
    t.index ["product_id"], name: "index_supermarket_prices_on_product_id"
    t.index ["supermarket_id"], name: "index_supermarket_prices_on_supermarket_id"
  end

  create_table "supermarkets", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "ai_requests", "users"
  add_foreign_key "favorite_menus", "menus"
  add_foreign_key "favorite_menus", "users"
  add_foreign_key "menu_ingredients", "ingredients"
  add_foreign_key "menu_ingredients", "menus"
  add_foreign_key "menus", "ai_requests"
  add_foreign_key "menus", "users"
  add_foreign_key "messages", "chat_threads"
  add_foreign_key "supermarket_prices", "products"
end
