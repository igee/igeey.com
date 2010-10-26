class Feedback < ActiveRecord::Base
  validates :text, :presence   => true
end
