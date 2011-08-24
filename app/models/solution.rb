class Solution < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  
  validates :user_id,:problem_id,:title,:content, :presence=>true
end
