class GeosController < ApplicationController
  respond_to :html,:json
  before_filter :find_geo, :except => [:index,:new,:list,:selector]
    
  def index
    @venues = Venue.popular.limit(6)
    @geo = Geo.new(:name => '全国')
    @users = User.popular.limit(8)
    render :show
  end
  
  def show
    @venues = @geo.venues.popular.limit(8)
    @users = @geo.users.popular.limit(8)
  end
  
  def list
    @geos = Geo.all
    render :layout => false if params[:layout] == 'false'
  end
  
  def selector
    @root = Geo.find(params[:root])
      if @root.children.size > 0
        @geos = @root.children.collect{|r| {:name => r.name, :id => r.id} }
      else
        @geos = [ {:name => @root.name, :id => @root.id} ]
      end
    render :action => :selector, :locals => { :object => params[:object], :attr => params[:attr] },:layout => false
  end
    
  private
  def find_geo
    @geo = Geo.find(params[:id])
  end
  
end
