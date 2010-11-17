class PlanObserver < ActiveRecord::Observer

  def after_create(plan)
    User.reset_counters(plan.user.id,:plans)
    plan.user.check_badge_condition_on('plans')
    plan.calling.update_attribute(:has_new_plan ,true)
  end

  def after_save(plan)
  end
  
end
