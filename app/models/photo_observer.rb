class PhotoObserver < ActiveRecord::Observer
  #def after_create(photo)
  #  if photo.imageable.present?
  #    photo.imageable.update_attribute(:has_photo,true)
  #  end
  #  photo.user.check_badge_condition_on('photos_count')
  #end
  #
  #def after_destroy(photo)
  #  if photo.imageable.photos.empty?
  #    photo.imageable.update_attribute(:has_photo,false)
  #  end
  #end
end
