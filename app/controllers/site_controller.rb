class SiteController < ApplicationController
  before_filter :login_required, :except=> [:faq,:guide,:about,:report,:public,:more_public_timeline]  
  
  def more_timeline
    @following_venues_id_list = current_user.venue_followings.map(&:followable_id)
    @timeline = Event.where(:venue_id => @following_venues_id_list).paginate(:page => params[:page], :per_page => 10)
    render '/public/more_timeline',:layout => false
  end
  
  def public
    @timeline = Event.where(:eventable_type=>'Calling').limit(10)
  end
  
  def more_public_timeline
    @timeline = Event.where(:eventable_type=>'Calling').paginate(:page => params[:page], :per_page => 10)
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

end
