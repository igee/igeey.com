class SiteController < ApplicationController
  def index
    @requirements = Requirement.all
    @venues = Venue.all
  end

end
