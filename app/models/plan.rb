class Plan < ActiveRecord::Base
  belongs_to :venue
  belongs_to :task
  belongs_to :user,     :counter_cache => true
  has_many   :syncs,    :as => :syncable,    :dependent => :destroy
  belongs_to :parent,   :class_name => 'Plan',:foreign_key => :parent_id
  has_many   :children, :class_name => 'Plan' ,:foreign_key => :parent_id
  has_many   :comments, :as => :commentable,    :dependent => :destroy
  
  acts_as_ownable
  acts_as_eventable
  acts_as_taggable
  
  has_attached_file :cover, :styles => {:_90x64 => ["90x64#"],:max500x400 => ["500x400>"]},
                            :url=>"/media/:attachment/plans/:id/:style.:extension",
                            :default_style=> :_90x64,
                            :default_url=>"/defaults/:attachment/plan/:style.png"

  default_scope :order => 'created_at DESC'
  
  scope :undone ,where(:is_done => false)
  scope :done ,where(:is_done => true)

  validates :task_id, :content, :presence => true
  validates :user_id,    :presence   => true,:uniqueness => {:scope => :task_id}
  
  def formatted_plan_at
    date = self.plan_at
    "#{date.year == Date.today.year ? '' : "#{date.year}年"}#{date.month}月#{date.day}日"
  end

  def status
    self.task.status
  end
  
  def description
    "要参加#{task.venue.name}的行动：#{self.task.title}"
  end

end
