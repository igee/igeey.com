class Grant < ActiveRecord::Base
  belongs_to :user
  belongs_to :badge
end
