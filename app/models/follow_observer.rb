class FollowObserver < ActiveRecord::Observer
  def after_create(follow)
    follow.user.check_badge_condition_on('followings_count')
    if follow.followable_type.to_s == "User"
      Notification.update(follow.user,follow)
    end
  end  
end
