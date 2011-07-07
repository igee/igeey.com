class Problem < ActiveRecord::Base
  belongs_to :user
  has_many   :cases, :dependent => :destroy
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  
  validates :name,:user_id, :presence => true
  
  default_scope     :order => 'created_at desc'
end
