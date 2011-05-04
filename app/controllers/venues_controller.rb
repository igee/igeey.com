class VenuesController < ApplicationController
  respond_to :html,:json
  before_filter :login_required, :except => [:index, :show,:records,:followers,:more_timeline,:position,:watching]
  before_filter :find_venue, :except => [:index,:new,:create]
  
  def index
    if logged_in?
      @following_venues_id_list = current_user.venue_followings.map(&:followable_id)
      @timeline = Event.where(:venue_id => @following_venues_id_list).limit(10)
    else
      @timeline = Event.limit(10)
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
    @callings = @venue.callings.limit(11)
    @photos = @venue.photos.limit(11)
    @sayings = @venue.sayings.limit(11)
    @topics = @venue.topics.limit(11)
    @timeline = @venue.events.limit(11)
    @followers = @venue.followers.limit(8)
  end
  
  def more_timeline
    if ['photos','sayings','topics','callings'].include?(params[:filter])
      @timeline = eval "@venue.#{params[:filter]}.paginate(:page => params[:page], :per_page => 10)"
      @filter = params[:filter]
    else
      @timeline = @venue.events.paginate(:page => params[:page], :per_page => 10)
    end
    render '/public/more_timeline',:layout => false
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
    @items = @venue.records.paginate(:page => params[:page], :per_page => 10)
    @title = "#{@venue.name}的行动记录"
    render 'see_all'
  end
  
  def callings
    @items = @venue.callings.paginate(:page => params[:page], :per_page => 10)
    @title = "#{@venue.name}的行动召集"
    render 'see_all'
  end
  
  def topics
    @items = @venue.topics.paginate(:page => params[:page], :per_page => 10)
    @title = "#{@venue.name}的故事"
    render 'see_all'
  end
  
  def sayings
    @items = @venue.sayings.paginate(:page => params[:page], :per_page => 10)
    @title = "#{@venue.name}的报到"
    render 'see_all'
  end
  
  def photos
    @items = @venue.photos.paginate(:page => params[:page], :per_page => 10)
    @title = "#{@venue.name}的照片"
    render 'see_all'
  end
  
  def followers
    @items = @venue.followers.paginate(:page => params[:page], :per_page => 10)
    @title = "#{@venue.name}的关注者"
    render 'see_all'
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
