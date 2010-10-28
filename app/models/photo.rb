class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :imageable, :polymorphic => true
  default_scope :order => 'created_at DESC'
  
  has_attached_file :photo, :styles => {:_90x64 => ["90x64#"],:max500x400 => ["500x400>"]},
                            :url=>"/media/:attachment/:id/:style.:extension",
                            :default_style=> :_90x64,
                            :default_url=>"/defaults/:attachment/:style.png"
  
  validates :photo_file_name, :presence   => true,:format => { :with => /([\w-]+\.(gif|png|jpg))|/ }
  
  def can_edit_by?(current_user)
    self.user == current_user
  end
  
end
