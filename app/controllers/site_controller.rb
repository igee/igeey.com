class SiteController < ApplicationController
  def index
    @requirements = Requirement.limit(8)
    @venues = Venue.all
    @plan = Plan.new     #can create new plan on this page 
  end

end
