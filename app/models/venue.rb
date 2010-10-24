class Venue < ActiveRecord::Base
  
  CATEGORIES_HASH = {'1' => '学校','2' => '村庄','3' => '公共场所','4' => '自然环境','5' => '其它'}
  
  
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :geo
  
  has_many   :requirements
  has_many   :plans
  has_many   :records
  has_many   :photos,     :as => :imageable,   :dependent => :destroy
  has_many   :follows,    :as => :followable,  :dependent => :destroy
  has_many   :followers,  :through => :follows, :source => :user
  

  has_attached_file :cover, :styles => {:_160x120 => ["160x120#"],:_80x60 => ["80x60#"]},
                            :url=>"/media/:attachment/venues/:id/:style.:extension",
                            :default_style=> :_160x120,
                            :default_url=>"/defaults/:attachment/venue/:style.png"

  default_scope :order => 'created_at DESC'
  
  validates :name,:latitude,:longitude, :presence   => true
  validates :intro,:length     => { :within => 0..140 }
  validates :category,:inclusion => { :in => CATEGORIES_HASH.keys }
  validates :cover_file_name, :presence   => true,:format => { :with => /([\w-]+\.(gif|png|jpg))|/ }
  
  def category_name
    CATEGORIES_HASH[self.category]
  end
  
  def time_counter
    self.records.map(&:time).compact.sum
  end
  
  def money_counter
    self.records.map(&:money).compact.sum
  end

  def goods_counter
    self.records.map(&:goods).compact.sum
  end
end
