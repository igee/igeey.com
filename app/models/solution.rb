class Solution < ActiveRecord::Base
  belongs_to :user,        :counter_cache => true
  has_many   :votes,       :as => :voteable,     :dependent => :destroy
  has_many   :follows,     :as => :followable, :dependent => :destroy
  has_many   :followers,   :through => :follows,:source => :user
  has_many   :posts,       :dependent => :destroy
  has_many   :kases,       :dependent => :destroy
  has_many   :managements, :dependent => :destroy
  has_many   :blogs,       :dependent => :destroy
  has_many   :downloads,   :dependent => :destroy
  has_many   :sayings,     :dependent => :destroy
  has_many   :managers,    :through => :managements,:source => :user
    
  acts_as_taggable

  validates :user_id,:title,:usage,:intro, :presence=>true
  default_scope :order => 'offset_count DESC'
  
  has_attached_file :cover, :styles => {:max200x64 => ["200x64>"],:max500x400 => ["500x400>"]},
                            :url=>"/media/:attachment/solutions/:id/:style.:extension",
                            :default_style=> :max200x64,
                            :default_url=>"/defaults/:attachment/solution/:style.png"
  
  def managed_by?(user)
    user.present? && (user.is_admin || self.managers.include?(user))
  end
  
end
