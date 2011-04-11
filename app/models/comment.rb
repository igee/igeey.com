class Comment < ActiveRecord::Base
  belongs_to :user,:counter_cache => true
  belongs_to :commentable, :polymorphic => true,:counter_cache => true
  
  default_scope :order => 'created_at asc'
  scope :last_three,:order=> 'created_at desc',:limit => 3
  
  validates :content,:length => {:minimum => 1}
end
