class GeosController < ApplicationController
  before_filter :find_geo, :except => [:index,:new]
  
  
  def index
    @geos = Geo.all
  end
  
  def show  
  end

  private
  def find_geo
    @geo = Geo.find(params[:id])
  end

end
