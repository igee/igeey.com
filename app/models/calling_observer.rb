class CallingObserver < ActiveRecord::Observer

  def after_create(calling)
    calling.user.check_badge_condition_on('realtime_callings_count')
    calling.followers << calling.user
    calling.venue.follows.new(:user_id => calling.user_id).save
  end
  
  def before_validation(calling)
    calling.detail = calling.detail.strip
  end
end
