class Geo < ActiveRecord::Base
  has_many :venues
  
  DEFAULT_CENTER = [33.724339,105.1171875,4]  #map center of china 
end
