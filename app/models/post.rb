class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  has_many   :votes,       :as => :voteable,    :dependent => :destroy
  
  has_attached_file :photo, :styles => {:_240x180 => ["240x180#"],:_100x75=>["100x75#"],:max500x400 => ["500x400>"]},
                            :url=>"/media/posts/:id/:style.:extension",
                            :default_style=> :_100x75,
                            :default_url=>"/defaults/:attachment/:style.png"
  
  acts_as_taggable
  
  default_scope :order => 'offset_count DESC'
  before_save :init_geocodding

  def init_geocodding
    unless self.address.nil? || self.address.empty?
      response = Net::HTTP.get_response(URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=#{URI.escape(self.address)}&sensor=false"))
      json = ActiveSupport::JSON.decode(response.body)
      self.latitude, self.longitude = json["results"][0]["geometry"]["location"]["lat"], json["results"][0]["geometry"]["location"]["lng"]
    end
  end
  
  def get_url_host
    unless self.url.nil? || self.url.empty?
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
