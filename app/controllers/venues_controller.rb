class VenuesController < ApplicationController
  respond_to :html,:json
  before_filter :login_required, :except => [:index, :show,:mark_venue,:select_record_action]
  before_filter :find_venue, :except => [:index,:new,:create]
  
  def index
    @venues = Venue.all
    respond_with(@venues)
  end
  
  def new
    if params[:latitude].nil? || params[:longitude].nil?
      @geo = Geo.new(:latitude => Geo::DEFAULT_CENTER[0],:longitude => Geo::DEFAULT_CENTER[1],:zoom_level => Geo::DEFAULT_CENTER[2])
      render 'mark_latlng'
    else
      @venue = Venue.new(:latitude => params[:latitude],:longitude => params[:longitude],:geo_id => params[:geo_id])
    end
  end
  
  def edit
  end
  
  def update
    @venue.update_attributes(params[:venue])
    respond_with(@venue)
  end
  
  def create
    @venue = Venue.new(params[:venue])
    @venue.creator = current_user
    flash[:notice] = 'Venue was successfully created.' if @venue.save
    respond_with(@venue)
  end
  
  def show
    @timeline = @venue.callings
    @timeline += @venue.plans.undone
    @timeline += @venue.records
    @timeline = @timeline.sort{|x,y| y.created_at <=> x.created_at }
    @photo = Photo.new
    @photos = @venue.photos
    @followers = @venue.followers
  end
  
  def cover
    render :layout => false if params[:layout] == 'false'
  end
  
  private
  def find_venue
    @venue = Venue.find(params[:id])
  end

end
