class Saying < ActiveRecord::Base
  belongs_to :user,     :counter_cache => true
  belongs_to :venue,    :counter_cache => true
  
  acts_as_ownable
  acts_as_taggable
  acts_as_eventable

  has_many   :comments, :as => :commentable,     :dependent => :destroy
  has_many   :votes,    :as => :voteable,        :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  
  default_scope :order => 'created_at DESC'
  
  validates :content,:length => { :within => 1..140,:message => '限制字数在140字以内' }
  validates :user_id,:venue_id, :presence   => true
  
  def self.tag_list
    Tagging.where(:taggable_type => self.to_s).limit(5)
  end
end
