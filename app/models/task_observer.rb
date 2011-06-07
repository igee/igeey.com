class TaskObserver < ActiveRecord::Observer

  def after_create(task)
    task.user.check_badge_condition_on('realtime_tasks_count')
  end
  
end
