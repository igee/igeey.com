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
  
  default_scope  where(:published => true).order('posts_count desc')
  
  def cover
    covered_post = self.posts.where('photo_file_name is not null').first
    covered_post.nil? ? nil : covered_post.photo
  end
  
  def send_new_problem
    Mailer.send_new_problem(self).deliver if self.save
  end

  define_index do
    indexes title
    indexes detail
  end
end
