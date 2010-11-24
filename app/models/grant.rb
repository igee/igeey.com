class Grant < ActiveRecord::Base
  belongs_to :user
  belongs_to :badge  
  validates :user_id,    :presence   => true,:uniqueness => {:scope => :badge_id}
  
  default_scope :order => 'created_at DESC'
end
