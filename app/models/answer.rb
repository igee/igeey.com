class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question, :counter_cache => true
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  
  acts_as_ownable
  validates :content,:length => {:minimum => 1 ,:message => '回答要有起码的字数吧？'}
  validates :user_id,:question_id,:presence => true
end
