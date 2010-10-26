class Feedback < ActiveRecord::Base
  validates :text, :presence   => true
  
  default_scope :order => 'created_at DESC'
  
end
