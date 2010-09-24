class Record < ActiveRecord::Base
  belongs_to :user
  belongs_to :venue
end
