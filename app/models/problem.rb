class Problem < ActiveRecord::Base
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  has_many   :cases, :dependent => :destroy
  has_many   :comments, :as => :commentable, :dependent => :destroy
  
  validates :name,:creator_id, :presence => true
end
