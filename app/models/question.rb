class Question < ActiveRecord::Base
  belongs_to :user
  has_many   :answers
  acts_as_taggable
  
  default_scope :order => 'created_at DESC'
  
  def user_id
    nil
  end
  
  def venue_id
    nil
  end
end
