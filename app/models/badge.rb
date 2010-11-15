class Badge < ActiveRecord::Base
  has_many :grants
  has_many :owners,:through => :grant,:class_name => 'User'
  
  def grant_to?(user)
    user.grants.where(:badge_id => self.id).present?
  end
end
