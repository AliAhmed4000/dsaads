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

ActiveRecord::Schema.define(version: 2020_05_08_081517) do

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
    t.string "description"
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
    t.integer "custom_offer", default: 0
    t.integer "package_id"
    t.string "custom_status"
    t.string "message_for_seller"
    t.string "message_for_buyer"
    t.string "sender"
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
    t.integer "buyer_star", default: 0
    t.integer "seller_star", default: 0
  end

  create_table "currencies", force: :cascade do |t|
    t.string "country"
    t.float "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "faqs", force: :cascade do |t|
    t.string "question"
    t.string "answer"
    t.bigint "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level"
    t.index ["service_id"], name: "index_faqs_on_service_id"
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

  create_table "order_cancels", force: :cascade do |t|
    t.bigint "order_item_id"
    t.bigint "user_id"
    t.integer "reason"
    t.text "description"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level"
    t.integer "extend_delivery"
    t.integer "read", default: 0
    t.index ["order_item_id"], name: "index_order_cancels_on_order_item_id"
    t.index ["user_id"], name: "index_order_cancels_on_user_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "package_id"
    t.bigint "order_id"
    t.integer "price"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.string "description"
    t.string "file"
    t.datetime "starting_at"
    t.datetime "ending_at"
    t.datetime "delivered_at"
    t.datetime "completed_at"
    t.integer "revision_no"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["package_id"], name: "index_order_items_on_package_id"
  end

  create_table "order_refunds", force: :cascade do |t|
    t.integer "order_item_id"
    t.string "user_reason"
    t.string "admin_reason"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.integer "delivery_time"
    t.boolean "publish"
    t.integer "level"
    t.integer "sender"
    t.integer "customstatus", default: 0
    t.integer "user_id"
    t.integer "revision_number"
    t.index ["service_id"], name: "index_packages_on_service_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "order_item_id"
    t.bigint "user_id"
    t.float "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject"
    t.integer "status"
    t.index ["order_item_id"], name: "index_payments_on_order_item_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "photos", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "service_id"
    t.string "image"
    t.integer "level"
    t.index ["service_id"], name: "index_photos_on_service_id"
  end

  create_table "punches", id: :serial, force: :cascade do |t|
    t.integer "punchable_id", null: false
    t.string "punchable_type", limit: 20, null: false
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.datetime "average_time", null: false
    t.integer "hits", default: 1, null: false
    t.index ["average_time"], name: "index_punches_on_average_time"
    t.index ["punchable_type", "punchable_id"], name: "punchable_index"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "star"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.integer "buyer_id"
    t.integer "seller_id"
    t.integer "package_id"
    t.integer "order_item_id"
    t.string "attachment"
    t.integer "revision_id"
    t.integer "order_cancel_id"
  end

  create_table "revisions", force: :cascade do |t|
    t.bigint "order_item_id"
    t.bigint "buyer_id"
    t.integer "delivery"
    t.integer "price"
    t.integer "status"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "seller_id"
    t.index ["buyer_id"], name: "index_revisions_on_buyer_id"
    t.index ["order_item_id"], name: "index_revisions_on_order_item_id"
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
    t.integer "status", default: 0
    t.string "search_title"
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
    t.string "uid"
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
    t.string "user_name"
    t.integer "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.json "tokens"
    t.integer "currency", default: 0
    t.string "paypal_email"
    t.string "paypal_token"
    t.boolean "paypal_token_status", default: false
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

  create_table "wish_favorites", force: :cascade do |t|
    t.bigint "wish_id"
    t.bigint "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_wish_favorites_on_service_id"
    t.index ["wish_id"], name: "index_wish_favorites_on_wish_id"
  end

  create_table "wishes", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wishes_on_user_id"
  end

end
