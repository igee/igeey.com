class Topic < ActiveRecord::Base
  belongs_to :user,             :counter_cache => true
  belongs_to :venue,            :counter_cache => true
  belongs_to :last_replied_user,:class_name => 'User' ,:foreign_key => :last_replied_user_id
 
  acts_as_ownable
  acts_as_taggable
  acts_as_eventable
  
  has_many   :follows,:as => :followable,     :dependent => :destroy  
  has_many   :comments, :as => :commentable,  :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  has_many   :votes,    :as => :voteable,       :dependent => :destroy
  
  default_scope :order => 'last_replied_at DESC'
  
  validate  :title, :presence  => true
  validate  :content, :presence  => true
  
  def self.tag_list
    Tagging.where(:taggable_type => self.to_s).limit(5)
  end
  
  define_index do
    indexes title
    indexes content
  end
end
