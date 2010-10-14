class SiteController < ApplicationController
  def index
    @requirements = Requirement.all
    @venues = Venue.all
    @plan = Plan.new     #can create new plan on this page 
  end

end
