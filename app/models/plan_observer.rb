class PlanObserver < ActiveRecord::Observer

  def after_create(plan)
    User.reset_counters(plan.user.id,:plans)
    plan.user.check_badge_condition_on('plans_count')
    plan.calling.update_attribute(:has_new_plan ,true)
    plan.parent.update_attribute(:has_new_child ,true) if plan.parent.present?
    plan.followers << plan.user
    plan.venue.followers << plan.user
  end

  def after_save(plan)
  end
  
end
