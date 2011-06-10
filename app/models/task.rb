class Task < ActiveRecord::Base
  belongs_to :user,     :counter_cache => true
  belongs_to :venue,    :counter_cache => true
  has_many   :records
  has_many   :plans
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :syncs,    :as => :syncable,    :dependent => :destroy
  has_many   :photos,   :as => :imageable,   :dependent => :destroy
  has_many   :follows,  :as => :followable,  :dependent => :destroy
  has_many   :votes,    :as => :voteable,    :dependent => :destroy
  has_many   :followers,:through => :follows,:source => :user
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  
  acts_as_ownable
  acts_as_taggable
  acts_as_eventable  
  
  has_attached_file :cover, :styles => {:_56x56 => ["56x56#",:jpg],:_128x128 => ["128x128#",:jpg]},
                            :url=>"/media/:attachment/tasks/:id/:style.jpg",
                            :default_style=> :_128x128,
                            :default_url=>"/defaults/:attachment/task/:style.png"
  
  default_scope :order => 'created_at DESC'
  
  scope :not_closed,where(:close => false) 
  
  validates :user_id,:venue_id,:title,  :presence => true
  validates :do_at,:date => {:after_or_equal_to => Date.today ,:allow_nil => true,:on => :create}
  
  def undone_plans_count
    self.plans.undone.size
  end
  
  def status
    text = "#{self.plans.empty? ? '还没有' : self.undone_plans_count}人认领"
    text += ",#{self.records.count}人完成" unless self.records.empty?
    text
  end
   
  def formatted_do_at
    date = self.do_at
    "#{date.year == Date.today.year ? '' : "#{date.year}年"}#{date.month}月#{date.day}日"
  end
  
  def description
    "为#{self.venue.name}发起行动：#{self.title}，请大家踊跃报名！"
  end
  
  def self.tag_list
    Tagging.where(:taggable_type => self.to_s).limit(5)
  end
  
  def related_tasks
    tasks = []
    self.tags.each do |tag|
      tasks += tag.taggeds.where(['taggable_type=?','Task']).limit(5).map(&:taggable)
    end
    (tasks - [self]).uniq.shuffle
  end
  
  define_index do
    indexes title
    indexes detail
    indexes venue.name ,:as => :venue
    indexes venue.geo.name ,:as => :city
    has venue_id
  end
  
end
