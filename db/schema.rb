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

ActiveRecord::Schema.define() do

  create_table "actions", :force => true do |t|
    t.string  :name,        :limit => 40
    t.string  :slug,        :limit => 40
    t.string  :for_what,    :limit => 40
    t.boolean :is_callable, :default => true
    t.text    :intro
    t.text    :step_by_step
  end

  create_table "badges", :force => true do |t|
    t.string  :name,             :limit => 40
    t.string  :slug,             :limit => 40
    t.string  :condition_factor, :limit => 40
    t.integer :condition_number
    t.string  :cover_file_name
    t.text    :intro
  end
  
  create_table "grants", :force => true do |t|
    t.integer  :user_id,    :null => false
    t.integer  :badge_id
    t.boolean  :unread,     :default => true
    t.timestamps
  end
  
  create_table "comments", :force => true do |t|
    t.integer  :user_id,    :null => false
    t.text     :content
    t.integer  :commentable_id
    t.string   :commentable_type, :limit => 40
    t.boolean  :has_new_comment,  :default => false
    t.timestamps
  end

  create_table "follows", :force => true do |t|
    t.integer  :user_id,    :null => false
    t.boolean  :unread,           :default => true
    t.integer  :followable_id
    t.string   :followable_type, :limit => 40
    t.timestamps
  end

  create_table "feedbacks", :force => true do |t|
    t.string   :text
    t.string   :email
    t.timestamps
  end
  
  create_table "geos", :force => true do |t|
    t.string  :name,       :limit => 40
    t.integer :parent_id
    t.integer :lft
    t.integer :rgt
    t.integer :zipcode
    t.integer :zoom_level
    t.string  :slug,       :limit => 40
    t.string  :latitude,   :limit => 40
    t.string  :longitude,  :limit => 40    
  end

  create_table "plans", :force => true do |t|
    t.integer  :user_id
    t.integer  :venue_id
    t.integer  :action_id
    t.integer  :calling_id
    t.integer  :record_id
    t.integer  :parent_id
    t.integer  :money
    t.integer  :goods
    t.datetime :plan_at
    t.integer  :comments_count,   :default => 0
    t.boolean  :has_new_child,    :default => false
    t.boolean  :has_new_comment,  :default => false
    t.boolean  :is_done,  :default => false
    t.datetime :last_replied_at
    t.integer  :last_replied_user_id
    t.timestamps
  end

  create_table "photos", :force => true do |t|
    t.integer  :user_id
    t.integer  :venue_id
    t.integer  :imageable_id
    t.string   :imageable_type
    t.string   :title,       :limit => 40
    t.text     :detail
    t.string   :photo_file_name
    t.integer  :comments_count,   :default => 0
    t.boolean  :has_new_comment,  :default => false
    t.datetime :last_replied_at
    t.integer  :last_replied_user_id
    t.timestamps
  end
  
  #create_table "projects", :force => true do |t|
  #  t.integer  :user_id
  #  t.string   :name,       :limit => 40
  #  t.text     :intro
  #  t.string   :website
  #  t.string   :tag,        :limit => 40
  #  t.string   :cover_file_name
  #  t.integer  :follows_count,             :default => 0
  #end
  
  create_table "records", :force => true do |t|
    t.integer  :user_id
    t.integer  :venue_id
    t.integer  :action_id
    t.integer  :plan_id
    t.integer  :calling_id
    t.integer  :parent_id
    
    t.integer  :money
    t.integer  :goods
    t.integer  :time
    t.integer  :online
    t.string   :title,       :limit => 40
    t.string   :latitude,    :limit => 40
    t.string   :longitude,   :limit => 40
        
    t.datetime :done_at
    t.text     :detail
    t.integer  :comments_count,   :default => 0
    t.boolean  :has_new_comment,  :default => false
    t.datetime :last_replied_at
    t.integer  :last_replied_user_id
    t.timestamps
  end

  create_table "users", :force => true do |t|
    t.string   :login,                     :limit => 40
    t.string   :name,                      :limit => 100, :default => ""
    t.string   :email,                     :limit => 100
    t.string   :crypted_password,          :limit => 40
    t.string   :salt,                      :limit => 40
    t.string   :avatar_file_name
    t.integer  :geo_id
    t.datetime :created_at
    t.datetime :updated_at
    t.integer  :follows_count,             :default => 0
    t.integer  :comments_count,            :default => 0
    t.integer  :callings_count,            :default => 0
    t.integer  :plans_count,               :default => 0
    t.integer  :records_count,             :default => 0
    t.integer  :photos_count,              :default => 0
    t.integer  :sayings_count,             :default => 0
    t.string   :remember_token,            :limit => 40
    t.datetime :remember_token_expires_at
    t.string   :signature
    t.boolean  :is_admin,                  :default => false
    t.boolean  :use_local_geo,             :default => false
  end
  
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  
  create_table "callings", :force => true do |t|
    t.integer  :venue_id
    t.integer  :action_id
    t.integer  :user_id    
    t.integer  :total_money
    t.integer  :total_online
    t.integer  :total_people
    t.integer  :total_goods
    t.string   :title,       :limit => 40   
    t.string   :address
    t.string   :contact
    t.text     :detail
    t.datetime :do_at
    t.boolean  :close,            :default => false
    t.integer  :follows_count,    :default => 0
    t.datetime :last_bumped_at
    t.string   :last_bumped_type, :limit => 40
    t.boolean  :has_new_plan,     :default => false
    t.integer  :comments_count,   :default => 0
    t.boolean  :has_new_comment,  :default => false
    t.datetime :last_replied_at
    t.integer  :last_replied_user_id
    t.timestamps
  end  

  create_table "venues", :force => true do |t|
    t.string  :name,         :limit => 40
    t.text    :intro
    t.string  :category,     :limit => 40
    t.string  :custom_category,     :limit => 40
    t.integer :geo_id
    t.integer :creator_id
    t.string  :latitude,     :limit => 40
    t.string  :longitude,    :limit => 40
    t.integer :zoom_level,   :default => 13
    t.string  :address
    t.string  :contact
    t.string  :cover_file_name
    t.integer :follows_count,:default => 0
    t.integer :photos_count,:default => 0
    t.integer :sayings_count,:default => 0
    t.integer :records_count,:default => 0
    t.timestamps
  end
  
  create_table "oauth_tokens",:force => true do |t|
    t.integer :user_id
    t.string  :request_key
    t.string  :request_secret
    t.string  :access_key
    t.string  :access_secret
    t.string  :site
    t.timestamps
  end
  
  create_table "syncs",:force => true do |t|
    t.integer  :user_id
    t.integer  :syncable_id
    t.string   :syncable_type, :limit => 40
    t.text     :content
    t.boolean  :sina,    :default => false
    t.boolean  :douban,  :default => false
    t.timestamps
  end
  
  create_table "topics",:force => true do |t|
    t.integer  :user_id
    t.integer  :venue_id
    t.string   :forumable_type
    t.integer  :forumable_id
    t.string   :title
    t.text     :content
    t.boolean  :has_new_comment,  :default => false
    t.integer  :comments_count,   :default => 0
    t.datetime :last_replied_at
    t.integer  :last_replied_user_id
    t.timestamps
  end
  
  create_table "sayings",:force => true do |t|
    t.integer  :user_id
    t.integer  :venue_id
    t.text     :content
    t.integer  :comments_count,   :default => 0
    t.boolean  :has_new_comment,  :default => 0
    t.datetime :last_replied_at
    t.integer  :last_replied_user_id
    t.timestamps
  end
  
create_table :tags do |t|
    t.column :name, :string
  end
  
  create_table :taggings do |t|
    t.column :tag_id, :integer
    t.column :taggable_id, :integer
    
    # You should make sure that the column created is
    # long enough to store the required class names.
    t.column :taggable_type, :string
    t.column :created_at, :datetime
  end
  
end
