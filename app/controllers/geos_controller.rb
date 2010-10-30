class GeosController < ApplicationController
  respond_to :html,:json
  before_filter :find_geo, :except => [:index,:new]
    
  def index
    @geos = Geo.all
    @venues = Venue.all
    @geo = Geo.new(:name => '全国')
    render :show
  end
  
  def show
    @venues = @geo.venues
  end

  private
  def find_geo
    @geo = Geo.find(params[:id])
  end

end
