class Venue < ActiveRecord::Base
  
  CATEGORIES_HASH = {'1' => '学校','2' => '村庄','3' => '公共场所','4' => '自然环境','5' => '其它'}
  
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  
  validates :name,:latitude,:longitude, :presence   => true
  validates :intro,:length     => { :within => 0..140 }
  validates :category,:inclusion => { :in => CATEGORIES_HASH.keys }
  
  def category_name
    CATEGORIES_HASH[self.category]
  end
  
  
end
