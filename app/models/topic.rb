class Topic < ActiveRecord::Base
  belongs_to :user
  belongs_to :venue
  belongs_to :last_replied_user,:class_name => 'User' ,:foreign_key => :last_replied_user_id
  
  has_many   :comments, :as => :commentable,    :dependent => :destroy
  default_scope :order => 'created_at DESC'
end
