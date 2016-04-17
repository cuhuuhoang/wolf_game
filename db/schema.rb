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

ActiveRecord::Schema.define(version: 20160417051542) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chatlogs", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "kind"
    t.string   "target"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "chatlogs", ["game_id"], name: "index_chatlogs_on_game_id", using: :btree
  add_index "chatlogs", ["user_id"], name: "index_chatlogs_on_user_id", using: :btree

  create_table "game_statuses", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "game_statuses", ["game_id"], name: "index_game_statuses_on_game_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.boolean  "is_current",  default: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "center_card"
  end

  create_table "locks", force: :cascade do |t|
    t.integer  "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.string   "char"
    t.string   "vote"
    t.integer  "original_role_id"
    t.integer  "current_role_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "players", ["current_role_id"], name: "index_players_on_current_role_id", using: :btree
  add_index "players", ["game_id"], name: "index_players_on_game_id", using: :btree
  add_index "players", ["original_role_id"], name: "index_players_on_original_role_id", using: :btree
  add_index "players", ["user_id"], name: "index_players_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "role_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "name"
    t.integer  "time_limit", default: -1
    t.integer  "delay_time", default: 2
    t.integer  "max_time",   default: -1
    t.datetime "begin_task"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "nick_name"
    t.boolean  "is_admin",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "wakeups", force: :cascade do |t|
    t.datetime "sleep_until"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "chatlogs", "games"
  add_foreign_key "chatlogs", "users"
  add_foreign_key "game_statuses", "games"
  add_foreign_key "players", "games"
  add_foreign_key "players", "users"
end
