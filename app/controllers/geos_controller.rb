class GeosController < ApplicationController
  respond_to :html,:json
  before_filter :find_geo, :except => [:index,:new,:list]
    
  def index
    @venues = Venue.popular.limit(6)
    @geo = Geo.new(:name => '全国')
    @users = User.popular.limit(8)
    if logged_in? && current_user.geo_id.present? && current_user.use_local_geo
      redirect_to geo_path(current_user.geo_id)
    else
      render :show
    end
  end
  
  def show
    @venues = @geo.venues.popular.limit(8)
    @users = @geo.users.popular.limit(8)
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
