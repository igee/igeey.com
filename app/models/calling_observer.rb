class CallingObserver < ActiveRecord::Observer

  def after_create(calling)
    User.reset_counters(calling.user.id,:callings)
    calling.user.check_badge_condition_on('callings_count')
  end

  def after_save(calling)
  end
  
end
