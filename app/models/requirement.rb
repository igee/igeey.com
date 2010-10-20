class Requirement < ActiveRecord::Base
  belongs_to :publisher, :class_name => "User", :foreign_key => "publisher_id"
  belongs_to :venue
  belongs_to :action
  has_many   :records
  has_many   :plans
  
  default_scope :order => 'created_at DESC'
    
  def users_count
    self.plans.map(&:user).uniq.size
  end
   
  def percentage
    if self.action.for_what == 'money'
      (self.records.map(&:money).sum*100 / self.total_money)
    elsif self.action.for_what == 'time'
      (self.plans.map(&:user).uniq.size*100 / self.total_people)
    elsif self.action.for_what == 'goods'
      (self.records.map(&:goods).sum*100 / self.total_goods)
    end
  end
end
