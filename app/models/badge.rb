class Badge < ActiveRecord::Base
  has_many :grants
  has_many :owners,:through => :grant,:class_name => 'User'
  
  has_attached_file :cover, :styles => {:_143x143 => ["143x143#"],:_50 => ["50x50#"]},
                            :url=>"/media/:attachment/:id/:style.:extension",
                            :default_style=> :_50x50,
                            :default_url=>"/defaults/:attachment/:style.png"
  
  validates :cover_file_name,:format => { :with => /([\w-]+\.(gif|png|jpg))|/ }
  
  def grant_to?(user)
    user.grants.where(:badge_id => self.id).present?
  end
end
