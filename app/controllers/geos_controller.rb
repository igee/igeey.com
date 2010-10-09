class GeosController < ApplicationController
  respond_to :html,:json
  before_filter :find_geo, :except => [:index,:new]
    
  def index
    @geos = Geo.all
  end
  
  def show
    @venues = @geo.venues
  end

  private
  def find_geo
    @geo = Geo.find(params[:id])
  end

end
