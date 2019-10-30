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

ActiveRecord::Schema.define(version: 2019_10_30_063859) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
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

  create_table "banners", force: :cascade do |t|
    t.bigint "admin_user_id"
    t.string "title"
    t.string "description"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_banners_on_admin_user_id"
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id"
    t.bigint "package_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["package_id"], name: "index_cart_items_on_package_id"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.integer "services_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.bigint "sub_category_id"
    t.index ["sub_category_id"], name: "index_categories_on_sub_category_id"
  end

  create_table "chats", force: :cascade do |t|
    t.integer "conversation_id"
    t.integer "user_id"
    t.text "message"
    t.boolean "deleted", default: false
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chats_recipients", force: :cascade do |t|
    t.integer "conversation_id"
    t.integer "chat_id"
    t.integer "user_id"
    t.boolean "read", default: false
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "seller_id"
    t.integer "buyer_id"
    t.integer "last_user_id"
    t.string "message"
    t.boolean "deleted"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_favorites_on_service_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "identities", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider"
    t.string "uid"
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "package_id"
    t.bigint "order_id"
    t.integer "price"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["package_id"], name: "index_order_items_on_package_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.string "shipping_status"
    t.integer "payment_status"
    t.string "username"
    t.string "address"
    t.string "phone"
    t.integer "sn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "package_metrics", force: :cascade do |t|
    t.bigint "package_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["package_id"], name: "index_package_metrics_on_package_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name"
    t.bigint "service_id"
    t.integer "price"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_commercial"
    t.integer "revision_number"
    t.integer "delivery_time"
    t.index ["service_id"], name: "index_packages_on_service_id"
  end

  create_table "photos", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "service_id"
    t.string "image"
    t.index ["service_id"], name: "index_photos_on_service_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "star"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.integer "buyer_id"
    t.integer "seller_id"
    t.bigint "package_id"
    t.index ["package_id"], name: "index_reviews_on_package_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "category_id"
    t.string "title"
    t.text "description"
    t.integer "favorites_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "requirements"
    t.boolean "publish", default: false
    t.index ["category_id"], name: "index_services_on_category_id"
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.bigint "admin_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_skills_on_admin_user_id"
  end

  create_table "user_certificates", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.string "institution_name"
    t.string "passing_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_certificates_on_user_id"
  end

  create_table "user_educations", force: :cascade do |t|
    t.bigint "user_id"
    t.string "country"
    t.string "institution_name"
    t.integer "title"
    t.string "major"
    t.string "passing_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_educations_on_user_id"
  end

  create_table "user_languages", force: :cascade do |t|
    t.bigint "user_id"
    t.string "language"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_languages_on_user_id"
  end

  create_table "user_occupations", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "occuption"
    t.integer "sub_occuption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_occupations_on_user_id"
  end

  create_table "user_skills", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "skill_id"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_skills_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "provider"
    t.integer "uid"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "avatar"
    t.string "language"
    t.string "country"
    t.integer "role", default: 0
    t.string "personal_web_link"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "last_name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.bigint "service_id"
    t.string "video"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_videos_on_service_id"
  end

end
