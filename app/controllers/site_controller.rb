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
    @following_venues = @user.following_venues
    @following_callings = @user.following_callings
    @following_users = @user.following_users
  end
  
  def actions
    @user = current_user
    @my_callings = @user.callings
    @my_plans = @user.plans.undone
    @my_records = @user.records
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
      @my_timeline = @my_timeline.uniq.sort{|x,y| y.created_at <=> x.created_at }[0..15]
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
    @topics = current_user.topics.where(:has_new_comment => true)
    @records = current_user.records.where(:has_new_comment => true)
    @callings = current_user.callings.where(:has_new_comment => true)
  end
  
  def unread_plans
    @callings = current_user.callings.where(:has_new_plan => true)
    @plans = current_user.plans.where(:has_new_child => true)
  end
  
end
