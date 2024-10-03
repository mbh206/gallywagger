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

ActiveRecord::Schema[7.2].define(version: 2024_09_24_232100) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string "home_team"
    t.string "away_team"
    t.datetime "start_time"
    t.string "sport"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "winning_team"
    t.string "time_zone"
    t.index ["start_time"], name: "index_games_on_start_time"
  end

  create_table "predictions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "game_id", null: false
    t.string "predicted_winner"
    t.string "confidence_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "points_awarded"
    t.index ["game_id"], name: "index_predictions_on_game_id"
    t.index ["user_id", "game_id"], name: "index_predictions_on_user_id_and_game_id"
    t.index ["user_id"], name: "index_predictions_on_user_id"
  end

  create_table "scores", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "total_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_scores_on_user_id"
  end

  create_table "season_scores", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "season_start"
    t.date "season_end"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_season_scores_on_user_id"
  end

  create_table "sports", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.string "logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "user_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weekly_scores", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "week_start"
    t.date "week_end"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_weekly_scores_on_user_id"
  end

  add_foreign_key "predictions", "games"
  add_foreign_key "predictions", "users"
  add_foreign_key "scores", "users"
  add_foreign_key "season_scores", "users"
  add_foreign_key "weekly_scores", "users"
end
