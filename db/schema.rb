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

ActiveRecord::Schema.define do

  create_table "actions", :force => true do |t|
    t.string  "name",       :limit => 40
    t.text    "intro"
    t.boolean "for_amount",   :default => false
    t.boolean "for_goods",    :default => false
    t.boolean "for_time",     :default => false
  end

  create_table "geos", :force => true do |t|
    t.string  "name",       :limit => 40
    t.integer "parent_id"
    t.integer "zipcode"
    t.integer "zoom_level"
    t.string  "slug",       :limit => 40
    t.string  "latitude",   :limit => 40
    t.string  "longitude",  :limit => 40
  end
    
  create_table "venues", :force => true do |t|
    t.string  "name",       :limit => 40
    t.text    "intro",      :limit => 255
    t.string  "category",   :limit => 40
    t.integer "geo_id"
    t.integer "creator_id"
    t.string  "latitude",   :limit => 40
    t.string  "longitude",  :limit => 40
  end
  
  create_table "profiles", :force => true do |t|
    t.integer "user_id"
  end

  create_table "records", :force => true do |t|
    t.integer "user_id"
    t.integer "venue_id"
    t.integer "action_id"
    t.integer "amount"
    t.integer "goods"
    t.integer "time"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  
end
