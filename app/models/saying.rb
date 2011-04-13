class Saying < ActiveRecord::Base
  belongs_to :user,     :counter_cache => true
  belongs_to :venue,    :counter_cache => true
  
  acts_as_taggable
  acts_as_eventable

  has_many   :comments, :as => :commentable,    :dependent => :destroy  
  
  default_scope :order => 'created_at DESC'
  
  validates :content,:length => { :within => 1..140,:message => '限制字数在140字以内' }

end
