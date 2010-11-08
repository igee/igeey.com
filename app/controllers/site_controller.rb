class SiteController < ApplicationController
  before_filter :login_required, :only=> [:unread_comments]
  
  def index
    # group callings,plans and records to list
    @public_timeline = Calling.limit(10)
    @public_timeline += Plan.limit(10)
    @public_timeline = @public_timeline.sort{|x,y| y.created_at <=> x.created_at }[0..10]
    @record_timeline = Record.limit(10)
    @my_plans = current_user.plans.undone if logged_in?
  end
  
  def my_timeline
    if logged_in?
      @my_timeline = []
      @my_followings = current_user.followings
      @my_followings.map(&:followable).each do |object|
        @my_timeline += object.records.limit(5) 
        @my_timeline += object.callings.limit(5)
        @my_timeline += object.plans.limit(5)
      end
      @my_timeline = @my_timeline.uniq.sort{|x,y| y.created_at <=> x.created_at }[0..10]
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
          @city_timeline += venue.callings.limit(5)
          @city_timeline += venue.plans.limit(5)
        end
        @city_timeline = @city_timeline.sort{|x,y| y.created_at <=> x.created_at }[0..10]
      end
    end
    render :layout => false
  end
  
  def unread_comments
    @plans = current_user.plans.where(:has_new_comment => true)
    @records = current_user.records.where(:has_new_comment => true)
    @callings = current_user.callings.where(:has_new_comment => true)
  end
    
end
