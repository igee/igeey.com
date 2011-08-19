class Blog < ActiveRecord::Base
  belongs_to :user
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  
  default_scope     :order => 'created_at desc'
  
  acts_as_ownable

  def summary
    self.content.split('<div id="delimiter"></div>')[0]
  end 
end
