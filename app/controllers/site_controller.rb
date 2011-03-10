class SiteController < ApplicationController
  before_filter :login_required, :except=> [:index,:faq,:guide,:about,:report]
  
  def index
    if logged_in?
      @timeline = []
      @followings = current_user.followings.where(:followable_type => 'Venue' ).map(&:followable)
      @followings.each do |v|
        @timeline += v.callings.not_closed.limit(10)
        @timeline += v.sayings.limit(10)
        @timeline += v.photos.limit(10)
      end
      @timeline = @timeline.uniq.sort{|x,y| y.created_at  <=> x.created_at  }[0..9]
    else
      @timeline = (Calling.limit(10) + Saying.limit(10)).sort{|x,y| y.created_at  <=> x.created_at  }[0..9]
    end
  end

  def followings
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
  
  def more_timeline
    @timeline = []
    @followings = current_user.followings.where(:followable_type => 'Venue' ).map(&:followable)
    @followings.each do |v|
      @timeline += v.callings.not_closed.limit(30)
      @timeline += v.sayings.limit(30)
      @timeline += v.photos.limit(30)
    end
    @timeline = @timeline.uniq.sort{|x,y| y.created_at  <=> x.created_at  }[0..200].paginate(:page => params[:page], :per_page => 10)
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
    @timeline = []
    @timeline += current_user.sayings.where(:has_new_comment => true)
    @timeline += current_user.photos.where(:has_new_comment => true)
    @timeline += current_user.topics.where(:has_new_comment => true)
    @timeline += current_user.callings.where(:has_new_comment => true)
    @timeline += current_user.records.where(:has_new_comment => true)
    @timeline += current_user.comments.where(:has_new_comment => true).map(&:commentable)
    @timeline = @timeline.uniq.sort{|x,y| y.last_replied_at <=> x.last_replied_at}
    @timeline.each do |i|
      i.update_attribute(:has_new_comment,false)
      i.comments.where(:user_id => current_user.id).map{|c| c.update_attribute(:has_new_comment,false)}
    end
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

end
