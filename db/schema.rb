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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101030155055) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "place_id",    :default => 0
    t.integer  "question_id", :default => 0
    t.integer  "answer_id",   :default => 0
    t.integer  "action_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.string   "description"
    t.integer  "up_counts",   :default => 0
    t.integer  "down_counts", :default => 0
    t.boolean  "is_choosen",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], :name => "answers_question_id_fk"

  create_table "followships", :force => true do |t|
    t.integer  "place_id",   :default => 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.decimal  "latitude",         :precision => 9, :scale => 6
    t.decimal  "longtitude",       :precision => 9, :scale => 6
    t.integer  "postalcode"
    t.string   "city"
    t.string   "pic_url"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "questions_count",                                :default => 0
    t.integer  "activities_count",                               :default => 0
  end

  create_table "qfollowships", :force => true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.integer  "place_id"
    t.string   "description"
    t.integer  "points",        :default => 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "answers_count", :default => 0
  end

  add_index "questions", ["place_id"], :name => "questions_place_id_fk"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "e_mail"
    t.integer  "scores"
    t.string   "profile_img"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.time     "remember_token_expires_at"
    t.string   "m_token"
    t.time     "m_token_expires_at"
  end

  add_foreign_key "answers", "questions", :name => "answers_question_id_fk"

  add_foreign_key "questions", "places", :name => "questions_place_id_fk"

end
