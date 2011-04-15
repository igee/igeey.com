class SiteController < ApplicationController
  before_filter :login_required, :except=> [:index,:faq,:guide,:about,:report,:public,:more_public_timeline]  
  def index
    if logged_in?
      @following_venues_id_list = current_user.venue_followings.map(&:followable_id)
      @timeline = Event.where(:venue_id => @following_venues_id_list).limit(10)
    else
      @timeline = Event.limit(10)
    end
  end
  
  def more_timeline
    @following_venues_id_list = current_user.venue_followings.map(&:followable_id)
    @timeline = Event.where(:venue_id => @following_venues_id_list)..paginate(:page => params[:page], :per_page => 10)
    @timeline = Event.paginate(:page => params[:page], :per_page => 10)
    render '/public/more_timeline',:layout => false
  end
  
  def public
    @timeline = Event.limit(20)
  end
  
  def more_public_timeline
    @timeline = Event.paginate(:page => params[:page], :per_page => 20)
    render '/public/more_timeline',:layout => false
  end

  def followings
    @venue_followings = current_user.venue_followings.paginate(:page => params[:venues_page], :per_page => 20)
    @calling_followings = current_user.calling_followings.paginate(:page => params[:callings_page], :per_page => 20)
    @user_followings = current_user.user_followings.paginate(:page => params[:users_page], :per_page => 20)
  end
  
  def actions
    @user = current_user
    @callings_timeline = @user.callings.paginate(:page => params[:callings_page], :per_page => 20)
    @plans_timeline = @user.plans.undone
    @records_timeline = @user.records.paginate(:page => params[:records_page], :per_page => 20)
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
