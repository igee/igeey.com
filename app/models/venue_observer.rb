class VenueObserver < ActiveRecord::Observer
  def after_create(venue)
    venue.class.generate_json
    venue.creator.check_badge_condition_on('venues_count')
    Follow.create(:user_id => venue.creator_id,:followable_id => venue.id,:followable_type => 'Venue')
  end
end
