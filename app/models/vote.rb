class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, :polymorphic => true,:counter_cache => true
  
  validates :user_id,        :presence   => true,:uniqueness => {:scope => [:voteable_type,:voteable_id]}
  validates :voteable_type,  :presence   => true
  validates :voteable_id,    :presence   => true
end
