class PlanObserver < ActiveRecord::Observer

  def after_create(plan)
    plan.task.update_attribute(:has_new_plan ,true)
    plan.parent.update_attribute(:has_new_child ,true) if plan.parent.present?
    plan.task.follows.new(:user_id => plan.user_id).save
    plan.user.check_badge_condition_on('realtime_plans_count') 
  end
  
end
