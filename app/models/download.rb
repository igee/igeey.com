class Download < ActiveRecord::Base
  belongs_to :solution
  
  has_attached_file :download, :url=>"/media/:attachment/:id/:basename.:extension"
end
