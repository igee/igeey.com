class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :solution
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  has_many   :votes,       :as => :voteable,    :dependent => :destroy
  
  acts_as_ownable
  
  default_scope :order => 'last_replied_at DESC'
  
end
