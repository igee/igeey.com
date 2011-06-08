class SiteController < ApplicationController
  before_filter :login_required, :except=> [:index,:faq,:guide,:about,:report,:public,:more_public_timeline,:timeline]  
  
  def index
    @questions = Question.unscoped.order('last_answered_at desc').limit(10)
    @tasks = Task.limit(6)
    @tags = Tag.limit(24)
    @question = Question.new
  end
  
  def timeline
    if logged_in?
      @following_venues_id_list = current_user.venue_followings.map(&:followable_id)
      @timeline = Event.where(:venue_id => @following_venues_id_list).limit(10)
    else
      @timeline = Event.limit(10)
    end
  end
  
  def more_timeline
    @following_venues_id_list = current_user.venue_followings.map(&:followable_id)
    @timeline = Event.where(:venue_id => @following_venues_id_list).paginate(:page => params[:page], :per_page => 10)
    render '/public/more_timeline',:layout => false
  end
  
  def public
    @timeline = Event.where(:eventable_type=>'Task').limit(10)
  end
  
  def more_public_timeline
    @timeline = Event.paginate(:page => params[:page], :per_page => 6)
    render '/public/more_timeline',:layout => false
  end

  def followings
    @venue_followings = current_user.venue_followings.paginate(:page => params[:venues_page], :per_page => 20)
    @task_followings = current_user.task_followings.paginate(:page => params[:tasks_page], :per_page => 20)
    @user_followings = current_user.user_followings.paginate(:page => params[:users_page], :per_page => 20)
  end
  
  def actions
    @user = current_user
    @tasks_timeline = @user.tasks.paginate(:page => params[:tasks_page], :per_page => 20)
    @plans_timeline = @user.plans.undone
    @records_timeline = @user.records.paginate(:page => params[:records_page], :per_page => 20)
  end

end
