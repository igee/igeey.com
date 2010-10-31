class Geo < ActiveRecord::Base
  acts_as_nested_set
  
  has_many :venues
  
  validates :name,:latitude,:longitude, :presence   => true
  validates :name,:uniqueness => true
    
  DEFAULT_CENTER = [33.724339,105.1171875,4]  #center position of china 
end
