class Solution < ActiveRecord::Base
  belongs_to :user,        :counter_cache => true
  belongs_to :problem,     :counter_cache => true
  has_many   :comments,    :as => :commentable, :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  has_many   :votes,       :as => :voteable,    :dependent => :destroy
    
  validates :user_id,:problem_id,:title,:content, :presence=>true
end
