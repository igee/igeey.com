class SiteController < ApplicationController
  before_filter :login_required, :except=> [:index,:faq,:guide,:about,:report]
  
  def index
    @calling_timeline = Calling.not_closed.limit(logged_in? ? 15 : 5)
    @plan_timeline = Plan.limit(logged_in? ? 15 : 5)
    @record_timeline = Record.limit(logged_in? ? 15 : 5)
  end
  
  def myigeey
    @user = current_user
    @my_actions = @user.callings + @user.plans.undone + @user.records
    @my_actions = @my_actions.sort{|x,y| y.created_at <=> x.created_at }
    @my_followings = @user.followings.map(&:followable)
    @geo = Geo.new(:name => '全国')
    @my_plans = current_user.plans.undone if logged_in?
  end

  def followings
    @user = current_user
    @following_venues = @user.following_venues.paginate(:page => params[:venues_page], :per_page => 20)
    @following_callings = @user.following_callings.paginate(:page => params[:callings_page], :per_page => 20)
    @following_users = @user.following_users.paginate(:page => params[:users_page], :per_page => 20)
  end
  
  def actions
    @user = current_user
    @my_callings = @user.callings.paginate(:page => params[:callings_page], :per_page => 20)
    @my_plans = @user.plans.undone
    @my_records = @user.records.paginate(:page => params[:records_page], :per_page => 20)
  end
  
  def my_timeline
    # group callings,plans and records to list
    if logged_in?
      @my_followings = current_user.followings
      @my_timeline = current_user.following_callings
      @my_followings.where("followable_type != ?",'Calling' ).map(&:followable).each do |object|
        @my_timeline += object.records.limit(5) 
        @my_timeline += object.callings.not_closed.limit(5)
        @my_timeline += object.plans.limit(5)
      end
      @my_timeline = @my_timeline.uniq.sort{|x,y| y.created_at  <=> x.created_at  }[0..15]
    end
    render :layout => false
  end
  
  def city_timeline
    if logged_in?
      @city_timeline = []
      @geo = current_user.geo
      if @geo
        @geo.venues.each do |venue|
          @city_timeline += venue.records.limit(5) 
          @city_timeline += venue.callings.not_closed.limit(5)
          @city_timeline += venue.plans.limit(5)
        end
        @city_timeline = @city_timeline.sort{|x,y| y.created_at <=> x.created_at }[0..15]
      end
    end
    render :layout => false
  end
  
  def unread_comments
    @topics = current_user.topics.where(:has_new_comment => true) | current_user.comments.where(:has_new_comment => true,:commentable_type => "Topic").map(&:commentable)
    @records = current_user.records.where(:has_new_comment => true) | current_user.comments.where(:has_new_comment => true,:commentable_type => "Record").map(&:commentable)
    @callings = current_user.callings.where(:has_new_comment => true) | current_user.followings.where(:has_new_comment => true,:followable_type => "Calling").map(&:followable) | current_user.comments.where(:has_new_comment => true,:commentable_type => "Calling").map(&:commentable)
  end
  
  def unread_plans
    @callings = current_user.callings.where(:has_new_plan => true)
    @plans = current_user.plans.where(:has_new_child => true)
  end
  
end
