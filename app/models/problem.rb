class Problem < ActiveRecord::Base
  belongs_to :user
  has_many   :kases, :dependent => :destroy
  has_many   :posts, :dependent => :destroy
  has_many   :solutions, :dependent => :destroy
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  has_many   :votes,    :as => :voteable,    :dependent => :destroy
  has_many   :follows,  :as => :followable, :dependent => :destroy
  has_many   :followers,  :through => :follows,:source => :user
  
  validates :title, :presence => true
  
  default_scope     :order => 'created_at desc'
  
  def self.published
    Problem.where(:published => true)
  end
  
  def self.index_problems
    Problem.published.order('posts_count')
  end
  
  def send_new_problem
    Mailer.send_new_problem(self).deliver if self.save
  end

  define_index do
    indexes title
    indexes detail
  end
end
