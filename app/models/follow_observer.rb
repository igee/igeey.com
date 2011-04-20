class FollowObserver < ActiveRecord::Observer
  def after_create(follow)
    follow.user.check_badge_condition_on('followings_count')
    if follow.followable_type.to_s == "User"
      Notification.update([follow.followable_id], follow)
    end
  end  
end
