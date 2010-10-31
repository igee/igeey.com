class GeosController < ApplicationController
  respond_to :html,:json
  before_filter :find_geo, :except => [:index,:new,:list]
    
  def index
    @venues = Venue.hot
    @geo = Geo.new(:name => '全国')
    render :show
  end
  
  def show
    @venues = @geo.venues.hot
  end
  
  def list
    @geos = Geo.all
    render :layout => false if params[:layout] == 'false'
  end
  
  private
  def find_geo
    @geo = Geo.find(params[:id])
  end

end
