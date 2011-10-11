class Management < ActiveRecord::Base
  belongs_to :user
  belongs_to :solution,      :counter_cache => true
  
  validates  :user_id,      :presence   => true,:uniqueness => {:scope => [:solution_id]}
end
