class SiteController < ApplicationController
  before_filter :login_required, :except=> [:index,:faq,:guide,:about,:report]
  
  def index
    if logged_in?
      @timeline = current_user.calling_followings.map(&:followable)
      @followings = current_user.followings.where(:followable_type => 'Venue' ).map(&:followable)
      @followings.each do |v|
        @timeline += v.records.limit(5) 
        @timeline += v.callings.not_closed.limit(5)
        @timeline += v.plans.limit(5)
        @timeline += v.sayings.limit(5)
      end
      @timeline = @timeline.uniq.sort{|x,y| y.created_at  <=> x.created_at  }[0..15]
    else
      @timeline = Record.limit(10)
    end
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
    @venue_followings = @user.venue_followings.paginate(:page => params[:venues_page], :per_page => 20)
    @calling_followings = @user.calling_followings.paginate(:page => params[:callings_page], :per_page => 20)
    @user_followings = @user.user_followings.paginate(:page => params[:users_page], :per_page => 20)
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
      @my_timeline = current_user.calling_followings.map(&:followable)
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
  
  def unread_followers
    @follows = current_user.follows.where(:unread => true)
    @followers = @follows.map(&:user)
    @follows.map{|f| f.update_attribute(:unread,false)}
  end
  
  def unread_venues
    @unread_calling_venues = current_user.followings.where(:has_new_calling => true,:followable_type => "Venue").map(&:followable)
    @unread_topic_venues = current_user.followings.where(:has_new_topic => true,:followable_type => "Venue").map(&:followable)
  end
  
end
