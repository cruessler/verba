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

ActiveRecord::Schema.define(version: 20140512162956) do

  create_table "learnables", force: true do |t|
    t.string   "type"
    t.string   "lemma"
    t.string   "long_lemma"
    t.string   "phrase"
    t.string   "translation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "learnables", ["lemma"], name: "index_learnables_on_lemma"

  create_table "learnables_vocabularies", id: false, force: true do |t|
    t.integer "vocabulary_id", null: false
    t.integer "learnable_id",  null: false
  end

  add_index "learnables_vocabularies", ["learnable_id"], name: "index_learnables_vocabularies_on_learnable_id"
  add_index "learnables_vocabularies", ["vocabulary_id"], name: "index_learnables_vocabularies_on_vocabulary_id"

  create_table "ratings", force: true do |t|
    t.integer  "learnable_id"
    t.integer  "user_id"
    t.integer  "repetition"
    t.integer  "interval"
    t.datetime "next_review"
    t.float    "e_factor"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["learnable_id"], name: "index_ratings_on_learnable_id"
  add_index "ratings", ["next_review"], name: "index_ratings_on_next_review"
  add_index "ratings", ["rating"], name: "index_ratings_on_rating"
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_vocabulary_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "vocabularies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
