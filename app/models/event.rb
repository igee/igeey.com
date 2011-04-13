class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :venue
  belongs_to :eventable,  :polymorphic => true
  default_scope     :order => 'created_at desc',:include => [:user,:venue]
  validates :eventable_id,:uniqueness => {:scope => [:eventable_type]}
  validates :eventable_type,:eventable_id,:user_id,:venue_id, :presence => true
end