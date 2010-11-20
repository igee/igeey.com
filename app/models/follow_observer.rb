class FollowObserver < ActiveRecord::Observer
  def after_create(follow)
    follow.user.check_badge_condition_on('followings_count')
  end  
end
