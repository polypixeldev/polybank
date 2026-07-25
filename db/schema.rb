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

ActiveRecord::Schema[8.1].define(version: 2026_07_25_032015) do
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

  create_table "counterparties", force: :cascade do |t|
    t.string "counterparty_type"
    t.datetime "created_at", null: false
    t.string "logo_url"
    t.string "name"
    t.string "plaid_id"
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

  create_table "transactions", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "amount_cents", null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.string "currency", default: "USD", null: false
    t.date "date"
    t.datetime "deleted_at"
    t.string "memo"
    t.boolean "pending", default: false, null: false
    t.integer "pending_transaction_id"
    t.string "plaid_id"
    t.json "plaid_object"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["pending_transaction_id"], name: "index_transactions_on_pending_transaction_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.string "plaid_id"
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "sessions", "users"
end
