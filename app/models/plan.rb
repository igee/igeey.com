class Plan < ActiveRecord::Base
  belongs_to :venue
  belongs_to :action
  belongs_to :requirement
  belongs_to :user
  has_one    :record
  has_many   :comments, :as => 'commentable', :dependent => :destroy
  
  attr_accessor :sync_to_sina,:sync_to_douban,:sync_to_renren
  
  validates :user_id,:action_id,:requirement_id,:venue_id,:presence   => true
  
  def description
    "要为#{self.requirement.venue.name}#{self.requirement.action.name}。"
  end
  
end

