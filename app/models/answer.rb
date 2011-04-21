class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question, :counter_cache => true
  has_many   :comments, :as => :commentable, :dependent => :destroy
end
