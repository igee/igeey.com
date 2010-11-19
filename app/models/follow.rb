class Follow < ActiveRecord::Base
  belongs_to :user
  belongs_to :followable, :polymorphic => true,:counter_cache => true
  
  validates :user_id,          :presence   => true,:uniqueness => {:scope => [:followable_type,:followable_id]}
  validates :followable_type,  :presence   => true
  validates :followable_id,    :presence   => true
  
  default_scope :order => 'created_at DESC'
  
  
  def description
    "在关注这个行动的进展： #{self.followable.user.login}#{self.followable.description}"
  end
  
end
