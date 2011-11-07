# Kase = Case
class Kase < ActiveRecord::Base
  belongs_to :user,     :counter_cache => true
  belongs_to :solution,  :counter_cache => true
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  
  has_attached_file :photo, :styles => {:_240x180 => ["240x180#"],:_100x75=>["100x75#"],:max500x400 => ["500x400>"]},
                            :url=>"/media/kases/:id/:style.:extension",
                            :default_style=> :_100x75,
                            :default_url=>"/defaults/:attachment/:style.png"
                            
  default_scope :order => 'created_at desc'
  
  acts_as_ownable

  validates :photo_file_name,:intro,:address,:happened_at, :presence=>true, :format=>{ :with=>/([\w-]+\.(gif|png|jpg))|/ }
  
  before_save :init_geocodding


  def init_geocodding
    response = Net::HTTP.get_response(URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=#{URI.escape(self.address)}&sensor=false"))
    json = ActiveSupport::JSON.decode(response.body)
    self.latitude, self.longitude = json["results"][0]["geometry"]["location"]["lat"], json["results"][0]["geometry"]["location"]["lng"] if json
  end
  
  def generate_json
    require 'json'
    kases = self.problem.kases
    kases_json = []
    kases.each do |k|
      kases_json << {"kase" => {:id => k.id,
                      :intro => k.intro,
                      :latitude => k.latitude,
                      :longitude => k.longitude,
                      }}
    end
    
    file = File.open("#{RAILS_ROOT}/public/json/problem_kases/#{self.problem.id}.json", 'w')
    file.write kases_json.to_json
    file.close    
  end
  
  
  def description
    "为问题“#{self.problem.title}”提交了一个案例：#{short_text(self.intro,30)}"
  end
  
end
