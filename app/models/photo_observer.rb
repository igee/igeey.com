class PhotoObserver < ActiveRecord::Observer
  def after_create(photo)
    photo.user.check_badge_condition_on('photos_count')
  end
end
