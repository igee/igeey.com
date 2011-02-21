class Saying < ActiveRecord::Base
  belongs_to :user
  belongs_to :venue

  has_many   :comments, :as => :commentable,    :dependent => :destroy
  
  default_scope :order => 'last_replied_at DESC'
  
  validates :content,:length => { :within => 1..140,:message => '限制字数在140字以内' }
end
