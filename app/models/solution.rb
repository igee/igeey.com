class Solution < ActiveRecord::Base
  belongs_to :user,        :counter_cache => true
  belongs_to :problem,     :counter_cache => true
  has_many   :comments,    :as => :commentable, :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  has_many   :votes,       :as => :voteable,    :dependent => :destroy
    
  validates :user_id,:problem_id,:title,:content, :presence=>true
  default_scope :order => 'offset_count DESC'
  
  def uped_by?(user)
    self.votes.where(:user_id => user.id,:positive => true).first
  end

  def downed_by?(user)
    self.votes.where(:user_id => user.id,:positive => false).first
  end
  
  def upers
    self.votes.where(:positive => true).map(&:user)
  end
  
  def downers
    self.votes.where(:positive => false).map(&:user)
  end
  
  def rank
    self.problem.solutions.index(self) + 1
  end
end
