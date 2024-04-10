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

ActiveRecord::Schema[7.0].define(version: 2023_07_06_033441) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "balance_managers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "sender", null: false
    t.string "b_type", null: false
    t.bigint "customer_account_no", null: false
    t.bigint "agent_account_no", null: false
    t.decimal "old_balance", precision: 18, scale: 10, null: false
    t.decimal "amount", precision: 18, scale: 10, null: false
    t.decimal "commision", precision: 18, scale: 10, null: false
    t.decimal "last_balance", precision: 18, scale: 10, null: false
    t.string "transaction_id", null: false
    t.integer "status", null: false
    t.date "date", null: false
    t.string "message", default: "", null: false
    t.string "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "bank_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "message_id"
    t.string "text_message"
    t.string "sender"
    t.string "receiver"
    t.string "sim_slot"
    t.integer "sms_type"
    t.string "android_id"
    t.string "app_version"
    t.date "sms_date"
    t.boolean "is_active"
    t.string "user_id"
    t.string "transaction_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "modem_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "balance_check_USSD"
    t.string "cash_in_USSD"
    t.string "bank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "modems", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "sim_type"
    t.string "operator"
    t.string "phone_number"
    t.string "device_id"
    t.integer "sim_id"
    t.string "token"
    t.string "device_info"
    t.boolean "is_active"
    t.string "user_id"
    t.integer "modem_action"
    t.integer "pincode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "permissions"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.integer "pin_code"
    t.string "country"
    t.string "parent_id"
    t.string "phone"
    t.string "user_name"
    t.string "company_id"
    t.string "role_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
