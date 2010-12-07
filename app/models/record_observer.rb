class RecordObserver < ActiveRecord::Observer
  def after_create(record)
    if record.plan.present?
      record.plan.update_attribute(:is_done,true)
    end
    record.venue.follows.new(:user_id => record.user_id).save
  end
  
  def after_destroy(record)
    if record.plan.present?
      record.plan.update_attribute(:is_done,false)
    end
  end
end
