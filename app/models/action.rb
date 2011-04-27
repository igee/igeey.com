class Action < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag
  has_many   :follows,  :as => :followable, :dependent => :destroy
  
  has_attached_file :cover, :styles => {:_64x64 => ["64x64#",:jpg],:_32x32 => ["32x32#",:jpg],:_24x24 => ["24x24#",:jpg]},
                            :url=>"/media/:attachment/action/:id/:style.jpg",
                            :default_style=> :_64x64,
                            :default_url=>"/defaults/:attachment/action/:style.png"

end
