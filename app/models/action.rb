class Action < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag
    
  has_attached_file :cover, :styles => {:_64x64 => ["64x64#",:jpg],:_32x32 => ["32x32#",:jpg],:_24x24 => ["24x24#",:jpg]},
                            :url=>"/media/:attachment/action/:id/:style.jpg",
                            :default_style=> :_64x64,
                            :default_url=>"/defaults/:attachment/action/:style.png"

  def taggings
    self.tag.taggings
  end
  
  def questions
    self.taggings.where(:taggable_type=>"Question").map(&:taggable)
  end

end
