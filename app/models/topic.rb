class Topic < ActiveRecord::Base
  belongs_to :user,             :counter_cache => true
  belongs_to :venue,            :counter_cache => true
  belongs_to :last_replied_user,:class_name => 'User' ,:foreign_key => :last_replied_user_id
  has_many   :follows,:as => :followable,:dependent => :destroy  
  has_many   :comments, :as => :commentable,    :dependent => :destroy
  
  default_scope :order => 'last_replied_at DESC'
  
  validate  :title, :presence  => true
  validate  :content, :presence  => true

  define_index do
    indexes title
    indexes content
  end
end
