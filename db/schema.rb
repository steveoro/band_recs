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

ActiveRecord::Schema.define(:version => 20120807151613) do

  create_table "app_parameters", :force => true do |t|
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "code"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "a_string"
    t.boolean  "a_bool"
    t.integer  "a_integer"
    t.datetime "a_date"
    t.decimal  "a_decimal",       :precision => 10, :scale => 0
    t.decimal  "a_decimal_2",     :precision => 10, :scale => 0
    t.decimal  "a_decimal_3",     :precision => 10, :scale => 0
    t.decimal  "a_decimal_4",     :precision => 10, :scale => 0
    t.integer  "range_x"
    t.integer  "range_y"
    t.string   "a_name"
    t.string   "a_filename"
    t.integer  "code_type_1"
    t.integer  "code_type_2"
    t.integer  "code_type_3"
    t.integer  "code_type_4"
    t.text     "free_text_1"
    t.text     "free_text_2"
    t.text     "free_text_3"
    t.text     "free_text_4"
    t.boolean  "free_bool_1"
    t.boolean  "free_bool_2"
    t.boolean  "free_bool_3"
    t.boolean  "free_bool_4"
    t.text     "description"
  end

  add_index "app_parameters", ["code"], :name => "code", :unique => true

  create_table "authors", :force => true do |t|
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "name",       :limit => 100, :null => false
    t.integer  "user_id",    :limit => 8,   :null => false
  end

  add_index "authors", ["name"], :name => "name"
  add_index "authors", ["user_id"], :name => "user_id"

  create_table "bands", :force => true do |t|
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "name",         :limit => 80, :null => false
    t.text     "description"
    t.text     "notes"
    t.datetime "founded_on"
    t.datetime "disbanded_on"
    t.integer  "user_id",      :limit => 8,  :null => false
  end

  add_index "bands", ["disbanded_on"], :name => "disbanded_on"
  add_index "bands", ["founded_on"], :name => "founded_on"
  add_index "bands", ["name"], :name => "name", :unique => true
  add_index "bands", ["user_id"], :name => "user_id"

  create_table "musician4_bands", :force => true do |t|
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "band_id",     :null => false
    t.integer  "musician_id", :null => false
    t.datetime "joined_on"
    t.datetime "left_on"
    t.text     "notes"
  end

  add_index "musician4_bands", ["band_id", "musician_id"], :name => "band_id_musician_id", :unique => true
  add_index "musician4_bands", ["band_id"], :name => "band_id"
  add_index "musician4_bands", ["joined_on"], :name => "joined_on"
  add_index "musician4_bands", ["left_on"], :name => "left_on"
  add_index "musician4_bands", ["musician_id"], :name => "musician_id"

  create_table "musician4_recordings", :force => true do |t|
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "recording_id", :null => false
    t.integer  "musician_id",  :null => false
  end

  add_index "musician4_recordings", ["musician_id"], :name => "musician_id"
  add_index "musician4_recordings", ["recording_id", "musician_id"], :name => "recording_id_musician_id", :unique => true
  add_index "musician4_recordings", ["recording_id"], :name => "recording_id"

  create_table "musicians", :force => true do |t|
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "name",        :limit => 80, :null => false
    t.string   "nickname",    :limit => 20
    t.text     "description"
    t.integer  "user_id",     :limit => 8,  :null => false
  end

  add_index "musicians", ["name"], :name => "name", :unique => true
  add_index "musicians", ["nickname"], :name => "nickname"
  add_index "musicians", ["user_id"], :name => "user_id"

  create_table "recordings", :force => true do |t|
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "rec_code",    :limit => 80,                :null => false
    t.integer  "band_id",     :limit => 8,                 :null => false
    t.datetime "rec_date",                                 :null => false
    t.integer  "rec_order",                 :default => 0
    t.string   "description"
    t.text     "notes"
    t.integer  "user_id",     :limit => 8,                 :null => false
  end

  add_index "recordings", ["band_id"], :name => "band_id"
  add_index "recordings", ["rec_code"], :name => "rec_code", :unique => true
  add_index "recordings", ["rec_date", "rec_order"], :name => "rec_date_order"
  add_index "recordings", ["rec_date"], :name => "rec_date"
  add_index "recordings", ["user_id"], :name => "user_id"

  create_table "sessions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "session_id"
    t.text     "data"
  end

  create_table "songs", :force => true do |t|
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "name",       :limit => 80, :null => false
    t.integer  "author_id",  :limit => 8,  :null => false
    t.integer  "user_id",    :limit => 8,  :null => false
  end

  add_index "songs", ["author_id"], :name => "author_id"
  add_index "songs", ["name"], :name => "name"
  add_index "songs", ["user_id"], :name => "user_id"

  create_table "tag4_takes", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "tag_id",     :null => false
    t.integer  "take_id",    :null => false
    t.integer  "user_id",    :null => false
  end

  add_index "tag4_takes", ["tag_id", "take_id"], :name => "tag_id_take_id", :unique => true
  add_index "tag4_takes", ["tag_id"], :name => "tag_id"
  add_index "tag4_takes", ["take_id"], :name => "take_id"
  add_index "tag4_takes", ["user_id"], :name => "user_id"

  create_table "tags", :force => true do |t|
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "name",       :limit => 40, :null => false
    t.integer  "user_id",    :limit => 8,  :null => false
  end

  add_index "tags", ["name"], :name => "name", :unique => true
  add_index "tags", ["user_id"], :name => "user_id"

  create_table "takes", :force => true do |t|
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "recording_id", :limit => 8,                :null => false
    t.integer  "song_id",      :limit => 8
    t.integer  "ordinal",      :limit => 2, :default => 0, :null => false
    t.integer  "vote",         :limit => 2, :default => 0, :null => false
    t.text     "notes"
    t.integer  "user_id",      :limit => 8,                :null => false
    t.string   "file_name"
  end

  add_index "takes", ["ordinal"], :name => "ordinal"
  add_index "takes", ["recording_id"], :name => "recording_id"
  add_index "takes", ["song_id"], :name => "song_id"
  add_index "takes", ["user_id"], :name => "user_id"
  add_index "takes", ["vote"], :name => "vote"

  create_table "users", :force => true do |t|
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "name",                             :null => false
    t.string   "description"
    t.string   "hashed_pwd"
    t.string   "salt"
    t.integer  "authorization_level"
    t.integer  "user_id",             :limit => 8, :null => false
  end

  add_index "users", ["name"], :name => "name", :unique => true
  add_index "users", ["user_id"], :name => "user_id"

end
