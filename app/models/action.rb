class Action < ActiveRecord::Base
  validates :name,:uniqueness => true
  validates :for_what,:inclusion => { :in => ['money','time','goods'] }
end
