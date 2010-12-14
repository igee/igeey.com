class Venue < ActiveRecord::Base
  
  CATEGORIES_HASH = {'1' => '自然景观','2' => '居住区','3' => '公共设施','4' => '教育场所','5' => '服务场所','6' => '商业场所','7'=>'其他'}
    
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :geo
  
  has_many   :callings
  has_many   :plans
  has_many   :records
  has_many   :photos,     :as => :imageable,   :dependent => :destroy
  has_many   :follows,    :as => :followable,  :dependent => :destroy
  has_many   :followers,  :through => :follows,:source => :user
  has_many   :topics

  has_attached_file :cover, :styles => {:_160x120 => ["160x120#"],:_80x60 => ["80x60#"]},
                            :url=>"/media/:attachment/venues/:id/:style.:extension",
                            :default_style=> :_160x120,
                            :default_url=>"/defaults/:attachment/venue/:style.png"

  default_scope :order => 'created_at DESC'
  scope :popular,order('follows_count DESC')
  
  validates :name,:latitude,:longitude, :presence   => true
  validates :intro,:length     => { :within => 1..100,:message => '填请写100字以内的简介' }
  validates :category,:inclusion => { :in => CATEGORIES_HASH.keys}
  validates :cover_file_name,:format => { :with => /([\w-]+\.(gif|png|jpg))|/ }
  
  def category_name
    CATEGORIES_HASH[self.category]
  end
  
  def time_count
    self.records.map(&:time).compact.sum
  end
  
  def money_count
    self.records.map(&:money).compact.sum
  end

  def goods_count
    self.records.map(&:goods).compact.sum
  end
  
  def records_count
    self.records.size
  end
    
  def self.generate_json
    require 'json'
    venues = Venue.all
    venues_json = []
    venues.each do |v|
      venues_json << {"venue" => {:id => v.id,
                      :category => v.category,
                      :name => v.name,
                      :latitude => v.latitude,
                      :longitude => v.longitude,
                      }}
    end
    
    file = File.open("#{RAILS_ROOT}/public/json/venues.json", 'w')
    file.write venues_json.to_json
    file.close    
  end
  
  define_index do
    # fields
    indexes name, :sortable => true
    
  end
  
end
