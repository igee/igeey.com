class Tool < ActiveRecord::Base
  belongs_to :action
  belongs_to :project
  
  validates :action_id,    :presence   => true,:uniqueness => {:scope => :project_id}
end
