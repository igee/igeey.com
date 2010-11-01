class SiteController < ApplicationController
  before_filter :login_required, :only=> [:unread_comments]
  
  def index
    # group requirements,plans and records to list
    @public_timeline = Requirement.limit(10)
    @public_timeline += Record.limit(10)
    @public_timeline += Plan.limit(10)
    @public_timeline = @public_timeline.sort{|x,y| y.created_at <=> x.created_at }[0..10]
    @my_plans = current_user.plans.undone if logged_in?
  end
  
  def my_timeline
    if logged_in?
      @my_timeline = []
      @my_followings = current_user.followings
      @my_followings.map(&:followable).each do |object|
        @my_timeline += object.records.limit(5) 
        @my_timeline += object.requirements.limit(5)
        @my_timeline += object.plans.limit(5)
      end
      @my_timeline = @my_timeline.sort{|x,y| y.created_at <=> x.created_at }[0..10]
    end
    render :layout => false
  end
  
  def unread_comments
    @plans = current_user.plans.where(:has_new_comment => true)
    @records = current_user.records.where(:has_new_comment => true)
    @requirements = current_user.requirements.where(:has_new_comment => true)
  end
    
end
