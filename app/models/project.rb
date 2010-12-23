class Project < ActiveRecord::Base
  belongs_to :user
  has_many :tools  
  validates :name,:intro, :presence   => true
  
  has_attached_file :cover, :styles => {:_160x160 => ["160x160#"],:_80x80 => ["80x80#"]},
                            :url=>"/media/:attachment/projects/:id/:style.:extension",
                            :default_style=> :_160x160,
                            :default_url=>"/defaults/:attachment/project/:style.png"

end
