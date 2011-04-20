class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notifiable, :polymorphic => true
  
  validates :user_id,        :presence   => true,:uniqueness => {:scope => [:notifiable_type,:notifiable_id]}
  validates :notifiable_type,  :presence   => true
  validates :notifiable_id,    :presence   => true
  
  def self.update(users_id, notifiable)
    notifications = self.where(:user_id => users_id, :notifiable_id => notifiable.id, 
                    :notifiable_type => notifiable.class)
    old_user_ids = []
    notifications.each do |n|
      n.update_attribute(:unread, true)
      old_user_ids += [n.user_id]
    end
    if users_id.size != old_user_ids.size
      new_user_ids = users_id - old_user_ids
      self.create(new_user_ids.map{|id|  {:user_id => id, :notifiable => notifiable}})
    end
  end
  
  def self.delete(user_id, notifiable)
    r = self.where(:user_id => user_id, :notifiable_id => notifiable.id, 
                    :notifiable_type => notifiable.class, :unread => true).first
    unless r.nil?
      r.update_attribute(:unread, false)
    end
  end
  
  def self.get_unread_by_user_id(user_id)
    self.where(:user_id => user_id, :unread => true).order("updated_at desc")
  end
end
