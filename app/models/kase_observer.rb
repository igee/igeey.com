class KaseObserver < ActiveRecord::Observer
  def after_create(kase)
    kase.generate_json
  end
end
