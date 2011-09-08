class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  has_many   :votes,       :as => :voteable,    :dependent => :destroy
  
  acts_as_taggable
  
  default_scope :order => 'offset_count DESC'
  
  def get_url_host
    unless self.url.empty?
      host = (/https?:\/\/(.+?)\//.match(self.url).nil? ? /https?:\/\/(.+?)$/.match(self.url)[1] : /https?:\/\/(.+?)\//.match(self.url)[1])
    else
      host = 'www.igeey.com'
    end
  end
  
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
