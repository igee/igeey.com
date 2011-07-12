class Problem < ActiveRecord::Base
  belongs_to :user
  has_many   :cases, :dependent => :destroy
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  has_many   :votes,    :as => :voteable,    :dependent => :destroy
  
  validates :name,:user_id, :presence => true
  
  default_scope     :order => 'created_at desc'
  
  define_index do
    indexes name
  end
end
