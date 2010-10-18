class Action < ActiveRecord::Base
  validates :name,:uniqueness => true
end
