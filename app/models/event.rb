class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :venue
  belongs_to :eventable,  :polymorphic => true
  default_scope     :order => 'created_at asc',:include => [:user,:venue] 
end