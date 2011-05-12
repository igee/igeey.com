class Doing < ActiveRecord::Base
  belongs_to :user,     :counter_cache => true
  belongs_to :venue,    :counter_cache => true
  
  acts_as_ownable
  acts_as_taggable
  acts_as_eventable

  has_many   :comments, :as => :commentable,    :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  
  default_scope :order => 'created_at DESC'
  
end

