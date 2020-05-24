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

ActiveRecord::Schema.define(version: 2020_05_24_094642) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "learnables", id: :serial, force: :cascade do |t|
    t.string "type"
    t.string "lemma"
    t.string "long_lemma"
    t.string "phrase"
    t.string "translation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_flagged", default: false
    t.index ["lemma"], name: "index_learnables_on_lemma"
  end

  create_table "learnables_vocabularies", id: false, force: :cascade do |t|
    t.bigint "vocabulary_id", null: false
    t.bigint "learnable_id", null: false
    t.index ["learnable_id"], name: "index_learnables_vocabularies_on_learnable_id"
    t.index ["vocabulary_id"], name: "index_learnables_vocabularies_on_vocabulary_id"
  end

  create_table "ratings", id: :serial, force: :cascade do |t|
    t.integer "learnable_id"
    t.integer "user_id"
    t.integer "repetition"
    t.integer "interval"
    t.datetime "next_review"
    t.float "e_factor"
    t.integer "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["learnable_id"], name: "index_ratings_on_learnable_id"
    t.index ["next_review"], name: "index_ratings_on_next_review"
    t.index ["rating"], name: "index_ratings_on_rating"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "current_vocabulary_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vocabularies", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
