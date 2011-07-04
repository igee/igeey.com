class Problem < ActiveRecord::Base
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  
  has_attached_file :cover, :styles => {:_48x48 => ["48x48#",:jpg],:_100x100 => ["100x100#",:jpg]},
                            :url=>"/media/:attachment/problems/:id/:style.jpg",
                            :default_style=> :_100x100,
                            :default_url=>"/defaults/:attachment/problem/:style.png"
  
  validates :name,:creator_id, :presence => true
end
