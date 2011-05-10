class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notifiable, :polymorphic => true
  
  validates :user_id,        :presence   => true,:uniqueness => {:scope => [:notifiable_type,:notifiable_id]}
  validates :notifiable_type,:notifiable_id,   :presence   => true
  
  def self.update(notifiable,trigger)
    notifications = notifiable.notifications
    notifications.map{|n| n.update_attribute(:unread, true) unless n.user_id == trigger.user_id}

    if notifications.empty?
      notifiable.notifications.build(:user_id => notifiable.user_id,:unread => (notifiable.user_id != trigger.user_id)).save
    end
    notifiable.notifications.build(:user_id => trigger.user_id,:unread => false).save
  end
  
  def read
    self.update_attribute(:unread, false)
  end
end
