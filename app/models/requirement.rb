class Requirement < ActiveRecord::Base
  belongs_to :publisher, :class_name => "User", :foreign_key => "publisher_id"
  belongs_to :venue
  belongs_to :action
  has_many   :records
  has_many   :plans
  
  def users_count
    self.plans.map(&:user).uniq.size
  end
  
end
