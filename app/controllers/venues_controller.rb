class VenuesController < ApplicationController
  respond_to :html,:json
  before_filter :login_required, :except => [:index, :show,:position]
  after_filter  :clean_unread,:only => [:show]
  before_filter :find_venue, :except => [:index,:new,:create]
  
  def index
    if params[:user_id].present?
      @venues = User.find(params[:user_id]).records.map(&:venue)
    else
      @venues = Venue.all
    end
    respond_with(@venues)
  end
  
  def new
    if params[:latitude].blank? || params[:longitude].blank?
      redirect_to geos_path
    else
      @venue = Venue.new(:latitude => params[:latitude],:longitude => params[:longitude],:geo_id => params[:geo_id],:zoom_level => params[:zoom_level])
    end
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
    @photos = @venue.photos
    @topics = @venue.topics
    @followers = @venue.followers
  end
  
  def edit
  end
  
  def update
    @venue.update_attributes(params[:venue]) if @venue.creator == current_user
    if params[:back_path].present?
      redirect_to params[:back_path]
    else
      respond_with(@venue)
    end
  end

  def cover
    render :layout => false if params[:layout] == 'false'
  end
  
  def position
    render :layout => false if params[:layout] == 'false'
  end
  
  def records
      @records = @venue.records.find_tagged_with(params[:tag])
    respond_with(@records)
  end
  
  private
  def find_venue
    @venue = Venue.find(params[:id])
  end
  
  def clean_unread
    @venue.follows.where(:user_id => current_user.id).map{|g| g.update_attributes(:has_new_calling => false,:has_new_topic => false)} if logged_in?
  end

end
