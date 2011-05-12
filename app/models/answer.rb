class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question, :counter_cache => true
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  
  acts_as_ownable
  validates :content,:length => {:minimum => 1 ,:message => '回答要有起码的字数吧？'}
  validates :question_id,    :presence => true
  validates :user_id,        :presence   => true,:uniqueness => {:scope => [:question_id]}
end
