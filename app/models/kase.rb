# Kase = Case
class Kase < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  
  has_attached_file :photo, :styles => {:_170x127 => ["170x127#"],:_360x270 => ["360x270#"],:max500x400 => ["500x400>"]},
                            :url=>"/media/:attachment/:id/:style.:extension",
                            :default_style=> :_90x64,
                            :default_url=>"/defaults/:attachment/:style.png"
                            
  default_scope     :order => 'created_at desc'
end
