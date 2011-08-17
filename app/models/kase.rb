# Kase = Case
class Kase < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  has_many   :votes,    :as => :voteable,    :dependent => :destroy
  
  has_attached_file :photo, :styles => {:_170x127 => ["170x127#"],:_100x75=>["100x75#"],:_360x270 => ["360x270#"],:max500x400 => ["500x400>"]},
                            :url=>"/media/:attachment/:id/:style.:extension",
                            :default_style=> :_90x64,
                            :default_url=>"/defaults/:attachment/:style.png"
                            
  default_scope     :order => 'votes_count desc'
  
  validates :photo_file_name, :presence=>true, :format=>{ :with=>/([\w-]+\.(gif|png|jpg))|/ }
  
  def init_geocodding
    response = Net::HTTP.get_response(URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=#{URI.escape(self.address)}&sensor=false"))
    json = ActiveSupport::JSON.decode(response.body)
    self.latitude, self.longitude = json["results"][0]["geometry"]["location"]["lat"], json["results"][0]["geometry"]["location"]["lng"]
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
  
end
