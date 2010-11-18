class VenueObserver < ActiveRecord::Observer
  def after_create(venue)
    venue.class.generate_json
  end
end
