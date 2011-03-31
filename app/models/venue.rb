class Venue < ActiveRecord::Base
  
  CATEGORIES_HASH = { '1' => '自然景观',
                      '2' => '居住区',
                      '3' => '公共设施',
                      '4' => '教育场所',
                      '5' => '服务场所',
                      '6' => '商业场所',
                      '7' => '其他',
                      '8' => '乡村小学',
                      '9' => '城市'}
                      
  SHORT_CATEGORIES_HASH = {'2' => '居住区','3' => '公共设施','4' => '教育场所','8'=>'乡村小学'}

  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :geo
  
  has_many   :callings,   :dependent => :destroy
  has_many   :topics,     :dependent => :destroy
  has_many   :sayings,    :dependent => :destroy  
  has_many   :plans,      :dependent => :destroy
  has_many   :records,    :dependent => :destroy
  has_many   :photos,     :dependent => :destroy
  has_many   :follows,    :as => :followable,  :dependent => :destroy
  has_many   :followers,  :through => :follows,:source => :user,:dependent => :destroy


  has_attached_file :cover, :styles => {:_48x48 => ["48x48#",:jpg],:_100x100 => ["100x100#",:jpg]},
                            :url=>"/media/:attachment/venues/:id/:style.jpg",
                            :default_style=> :_100x100,
                            :default_url=>"/defaults/:attachment/venue/:style.png"
  
  validates :name,:latitude,:longitude,:creator_id, :presence   => true
  #validates :intro,:length     => { :within => 1..100,:message => '填请写100字以内的简介' }
  validates :category,:inclusion => { :in => CATEGORIES_HASH.keys}
  validates :cover_file_name,:format => { :with => /([\w-]+\.(gif|png|jpg))|/ }
  
  default_scope :order => 'follows_count desc'
  
  def category_name
    CATEGORIES_HASH[self.category]
  end
  
  def time_count
    self.records.map(&:time).compact.sum
  end
  
  def money_count
    self.records.map(&:money).compact.sum
  end
  
  def online_count
    self.records.map(&:online).compact.sum
  end

  def goods_count
    self.records.map(&:goods).compact.sum
  end
  
  def records_count
    self.records.size
  end
    
  def init_geocodding
    begin
      response = Net::HTTP.get_response(URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=#{URI.escape(self.address)},#{URI.escape(self.geo.name)}&sensor=false"))
      json = ActiveSupport::JSON.decode(response.body)
      self.latitude, self.longitude = json["results"][0]["geometry"]["location"]["lat"], json["results"][0]["geometry"]["location"]["lng"]
    rescue
      self.latitude, self.longitude = self.geo.latitude,self.geo.longitude
    end
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
    indexes name
    indexes intro
    indexes geo.name,:as => :city
    indexes address
    has geo_id
    has follows_count
  end
  
end
