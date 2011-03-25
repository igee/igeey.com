class VenuesController < ApplicationController
  respond_to :html,:json
  before_filter :login_required, :except => [:index, :show,:records,:followers,:more_timeline,:position,:watching]
  before_filter :find_venue, :except => [:index,:new,:create]
  
  def index
    @venues_hash = {}
    Venue::SHORT_CATEGORIES_HASH.each do |k,v|
      @venues_hash[v.to_sym] = Venue.where(:category => k).limit(6)
    end
  end
  
  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(params[:venue])
    @venue.creator = current_user
    @venue.init_geocodding
    flash[:notice] = 'Venue was successfully created.' if @venue.save
    respond_with(@venue)
  end
  
  def show
    @timeline = @venue.callings.limit(10)
    @timeline += @venue.records.where(:calling_id => nil).limit(10)
    @timeline += @venue.photos.limit(10)
    @timeline += @venue.sayings.limit(10)
    @timeline += @venue.topics.limit(10)
    @timeline = @timeline.sort{|x,y| y.created_at <=> x.created_at }[0..9]
    @followers = @venue.followers.limit(8)
  end
  
  def more_timeline
    @timeline = []
    @timeline += @venue.callings.not_closed.limit(30)
    @timeline += @venue.sayings.limit(30)
    @timeline += @venue.photos.limit(30)
    @timeline += @venue.topics.limit(30)
    @timeline = @timeline.sort{|x,y| y.created_at  <=> x.created_at}[0..200].paginate(:page => params[:page], :per_page => 10)
    render :layout => false
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
    @records = @venue.records
    respond_with(@records)
  end
  
  def followers
    @followers = @venue.followers.paginate(:page => params[:page], :per_page => 20)
  end
  
  def watching
    @venue.update_attribute(:watch_count,(@venue.watch_count + 1))
    render :text => 'OK'
  end
  
  private
  def find_venue
    @venue = Venue.find(params[:id])
  end
end
