class RecordObserver < ActiveRecord::Observer
  def after_create(record)
    if record.plan.present?
      record.plan.update_attribute(:is_done,true)
    end
  end
  
  def after_destroy(record)
    if record.plan.present?
      record.plan.update_attribute(:is_done,false)
    end
  end
end
