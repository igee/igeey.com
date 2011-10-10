class Solution < ActiveRecord::Base
  belongs_to :user,        :counter_cache => true
  has_many   :comments,    :as => :commentable,  :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  has_many   :votes,       :as => :voteable,     :dependent => :destroy
  has_many   :follows,       :as => :followable, :dependent => :destroy
  has_many   :topics,       :as => :forumable,   :dependent => :destroy
    
  acts_as_taggable

  validates :user_id,:title,:usage,:intro, :presence=>true
  default_scope :order => 'offset_count DESC'
  
  has_attached_file :cover, :styles => {:max200x64 => ["200x64>"],:max500x400 => ["500x400>"]},
                            :url=>"/media/:attachment/solutions/:id/:style.:extension",
                            :default_style=> :max200x64,
                            :default_url=>"/defaults/:attachment/solution/:style.png"

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
