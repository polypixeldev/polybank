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

ActiveRecord::Schema[8.1].define(version: 2026_08_07_060628) do
  create_table "accounts", force: :cascade do |t|
    t.string "account_type", null: false
    t.datetime "created_at", null: false
    t.string "mask"
    t.string "name", null: false
    t.string "plaid_id"
    t.integer "plaid_item_id"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["plaid_item_id"], name: "index_accounts_on_plaid_item_id"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "blazer_audits", force: :cascade do |t|
    t.datetime "created_at"
    t.string "data_source"
    t.integer "query_id"
    t.text "statement"
    t.integer "user_id"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.string "check_type"
    t.datetime "created_at", null: false
    t.integer "creator_id"
    t.text "emails"
    t.datetime "last_run_at"
    t.text "message"
    t.integer "query_id"
    t.string "schedule"
    t.text "slack_channels"
    t.string "state"
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "dashboard_id"
    t.integer "position"
    t.integer "query_id"
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "creator_id"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "creator_id"
    t.string "data_source"
    t.text "description"
    t.string "name"
    t.text "statement"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "budgets", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.integer "limit_amount_cents", null: false
    t.string "name", null: false
    t.string "period", null: false
    t.integer "target_id", null: false
    t.string "target_type", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["target_type", "target_id"], name: "index_budgets_on_target"
    t.index ["user_id"], name: "index_budgets_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "author_id", null: false
    t.integer "commentable_id", null: false
    t.string "commentable_type", null: false
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_comments_on_author_id"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
  end

  create_table "counterparties", force: :cascade do |t|
    t.string "counterparty_type"
    t.datetime "created_at", null: false
    t.string "custom_name"
    t.string "logo_url"
    t.string "plaid_id"
    t.string "plaid_name"
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["plaid_id"], name: "index_counterparties_on_plaid_id", unique: true
  end

  create_table "counterparty_transactions", force: :cascade do |t|
    t.integer "counterparty_id", null: false
    t.datetime "created_at", null: false
    t.integer "transaction_id", null: false
    t.datetime "updated_at", null: false
    t.index ["counterparty_id"], name: "index_counterparty_transactions_on_counterparty_id"
    t.index ["transaction_id"], name: "index_counterparty_transactions_on_transaction_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "aasm_state", default: "pending", null: false
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "dismissed_at"
    t.string "key"
    t.datetime "read_at"
    t.datetime "sent_at"
    t.integer "source_id"
    t.string "source_type"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["source_type", "source_id"], name: "index_notifications_on_source"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "plaid_items", force: :cascade do |t|
    t.string "access_token", null: false
    t.datetime "created_at", null: false
    t.string "item_id", null: false
    t.string "name"
    t.string "transaction_cursor"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_plaid_items_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tag_transactions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "tag_id", null: false
    t.integer "transaction_id", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_tag_transactions_on_tag_id"
    t.index ["transaction_id"], name: "index_tag_transactions_on_transaction_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "color", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "amount_cents", null: false
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.string "currency", default: "USD", null: false
    t.date "date"
    t.datetime "deleted_at"
    t.string "memo"
    t.boolean "pending", default: false, null: false
    t.integer "pending_transaction_id"
    t.string "plaid_id"
    t.json "plaid_object"
    t.integer "reimbursement_for_id"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["pending_transaction_id"], name: "index_transactions_on_pending_transaction_id"
    t.index ["plaid_id"], name: "index_transactions_on_plaid_id", unique: true, where: "deleted_at IS NULL"
    t.index ["reimbursement_for_id"], name: "index_transactions_on_reimbursement_for_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.boolean "is_admin", default: false, null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.string "plaid_id"
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "sessions", "users"
end
