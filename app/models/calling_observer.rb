class CallingObserver < ActiveRecord::Observer

  def after_create(calling)
    calling.user.check_badge_condition_on('realtime_callings_count')
    calling.followers << calling.user
    calling.venue.follows.map{|v|  v.update_attribute(:has_new_calling ,true)}
  end
  
  def before_validation(calling)
    calling.detail = calling.detail.strip
  end
end
