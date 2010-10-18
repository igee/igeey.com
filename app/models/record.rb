class Record < ActiveRecord::Base
  belongs_to :user
  belongs_to :venue
  belongs_to :action
  belongs_to :requirement
  
  default_scope :order => 'created_at DESC'
  
  attr_accessor :sync_to_sina,:sync_to_douban,:sync_to_renren
  
end
