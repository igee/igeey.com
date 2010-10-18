class VenuesController < ApplicationController
  respond_to :html,:json
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_venue, :except => [:index,:new,:create]
  
  def index
    @venues = Venue.all
    respond_with(@venues)
  end
  
  def new
    if params[:latitude].nil? || params[:longitude].nil?
      @geo = Geo.new(:latitude => Geo::DEFAULT_CENTER[0],:longitude => Geo::DEFAULT_CENTER[1],:zoom_level => Geo::DEFAULT_CENTER[2])
      @geos = Geo.all
      render 'mark_latlng'
    else
      @venue = Venue.new(:latitude => params[:latitude],:longitude => params[:longitude],:geo_id => params[:geo_id])
    end
  end
  
  def create
    @venue = Venue.new(params[:venue])
    @venue.creator = current_user
    flash[:notice] = 'Venue was successfully created.' if @venue.save
    respond_with(@venue)
  end
  
  def show
    @requirements = @venue.requirements
    @records = @venue.records
    @plan = Plan.new     #can create new plan on this page
  end
  
  def have_done
    @actions = Action.all
  end
  
  def publish_requirement
    @actions = Action.all
  end
  
  private
  def find_venue
    @venue = Venue.find(params[:id])
  end

end
