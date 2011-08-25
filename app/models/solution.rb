class Solution < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  
  validates :user_id,:problem_id,:title,:content, :presence=>true
end
