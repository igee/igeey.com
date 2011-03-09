class PlanObserver < ActiveRecord::Observer

  def after_create(plan)
    plan.calling.update_attribute(:has_new_plan ,true)
    plan.parent.update_attribute(:has_new_child ,true) if plan.parent.present?
    plan.calling.follows.new(:user_id => plan.user_id).save
    plan.user.check_badge_condition_on('realtime_plans_count') 
  end
  
end
