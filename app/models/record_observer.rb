class RecordObserver < ActiveRecord::Observer
  def after_create(comment)
    if comment.plan.present?
      comment.plan.update_attribute(:is_done,true)
    end
  end
  
  def after_destroy(comment)
    if comment.plan.present?
      comment.plan.update_attribute(:is_done,false)
    end
  end
end
