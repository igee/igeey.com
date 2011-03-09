class VenueObserver < ActiveRecord::Observer
  def after_create(venue)
    venue.class.generate_json
    venue.creator.check_badge_condition_on('venues_count')
  end
end
