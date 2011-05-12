class NotificationObserver < ActiveRecord::Observer
  def after_save(notification)
    notification.user.update_notifications_count
  end
end