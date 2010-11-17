class VenueObserver < ActiveRecord::Observer
  def after_create(venue)
    Venue.generate_json
  end
end
