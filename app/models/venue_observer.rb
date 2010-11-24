class VenueObserver < ActiveRecord::Observer
  def after_create(venue)
    venue.class.generate_json
    venue.creator.check_badge_condition_on('venues_count')
    venue.follows.new(:user_id => venue.creator_id).save
  end
end
