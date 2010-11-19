class Sync < ActiveRecord::Base
  belongs_to :syncable, :polymorphic => true
  belongs_to :user
end
