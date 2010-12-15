class SearchController < ApplicationController
  def result
    @keywords = params[:keywords]
    @venues = Venue.search(@keywords)
  end
end
