class Checkin < ActiveRecord::Base
  belongs_to :user
  belongs_to :venue

  has_many   :comments, :as => :commentable,    :dependent => :destroy
end
