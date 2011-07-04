class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  # include AuthenticatedSystem
  respond_to :html
  before_filter :login_required, :only=> [:edit,:setting]
  before_filter :find_user, :except => [:new,:create,:edit,:setting,:welcome,:index,:reset_password,
                                        :reset_completed,:connect_account,:oauth_signup,:oauth_user_create]

  # render new.rhtml
  def new
    redirect_to :root if logged_in?
    @user = User.new
    render :layout => false if params[:layout] == 'false'
  end
  
  def oauth_signup
    redirect_to :root if logged_in?
    @user = User.new
    @site = session[:site]
    @user_name = OauthToken.find_by_unique_id_and_site(session[:unique_id],@site).get_site_user_name
  end
  
  def oauth_user_create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      OauthToken.find_by_unique_id_and_site(session[:unique_id],session[:site]).update_attributes(:user_id => @user.id)
      flash[:dialog] = "<a href=#{welcome_users_path} class='open_dialog' title='欢迎'>欢迎</a>"
      redirect_to :back
    else
      render :action => 'oauth_signup' 
    end
  end
  
  def connect_account
    @token = OauthToken.find_by_user_id_and_request_key((current_user ? current_user.id : nil), params[:oauth_token])
    @unique_id = @token.unique_id
    @exist_tokens = OauthToken.where(:unique_id => @unique_id,:site => @token.site).where('user_id is not null')
    if @exist_tokens.empty?
      @token.update_attributes(:unique_id => @unique_id)
      session[:unique_id] = @unique_id
      session[:site] = @token.site
      redirect_to oauth_signup_path
    else
      @user = User.find @exist_tokens.first.user_id
      @exist_tokens.map(&:delete)
      @token.update_attributes(:user_id => @user.id)
      self.current_user = @user
      # auto login 
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_to((session[:oauth_refers]||{})[@token.site] || '/' )
    end
  end
  
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      flash[:dialog] = "<a href=#{welcome_users_path} class='open_dialog' title='欢迎'>欢迎</a>"
      redirect_to :back
    else
      render :action => 'new' 
    end
  end
  
  def welcome
    if params[:layout] == 'false'
      render :layout => false
    end  
  end
  
  def edit
    @user = current_user
  end
  
  def setting
    @user = current_user
  end
  
  def update
    @user.update_attributes(params[:user])
    redirect_to :back
  end
  
  def update_account
    @user.email = params[:email]
    @user.password = params[:password]
    if @user.password.length >= 6
      @user.encrypt_password
      @user.password = nil
      if @user.save
         logout_killing_session!
         redirect_to root_path
      else
        flash[:error] = "邮箱格式不正确"
        render :action => :edit
      end
    else
      flash[:error] = "密码长度不足"
      render :action => :edit
    end
  end
  
  def index
    redirect_back_or_default('/')
  end
  
  def show
    @timeline = @user.events.limit(11)
    @questions = @user.questions.limit(11)
    @answers = @user.answers.order('created_at desc').limit(11)
    @followers = @user.followers.limit(9)
    @following_users = @user.user_followings.limit(9).map(&:followable)
    @following_venues = @user.venue_followings.limit(11).map(&:followable)
    @badges = @user.grants.limit(9).map(&:badge)
  end
  
  def badges
    @items = @user.badges.paginate(:page => params[:page], :per_page => 10)
    @title = "#{@user.login}获得的徽章"
    render 'see_all'
  end
  
  def tasks
    @items = @user.tasks.paginate(:page => params[:page], :per_page => 10)
    @title = "#{@user.login}的任务"
    render 'see_all'
  end
  
  def topics
    @items = @user.topics.paginate(:page => params[:page], :per_page => 10)
    @title = "#{@user.login}的故事"
    render 'see_all'
  end
  
  def sayings
    @items = @user.sayings.paginate(:page => params[:page], :per_page => 10)
    @title = "#{@user.login}的报到"
    render 'see_all'
  end
  
  def photos
    @items = @user.photos.paginate(:page => params[:page], :per_page => 10)
    @title = "#{@user.login}的照片"
    render 'see_all'
  end
  
  def questions
    @items = @user.questions.paginate(:page => params[:page], :per_page => 10)
    @title = "#{@user.login}的问题"
    render 'see_all'
  end
  
  def answers
    @items = @user.answers.order('created_at desc').paginate(:page => params[:page], :per_page => 10)
    @title = "#{@user.login}的回答"
    render 'see_all'
  end
  
  def plans
    @items = @user.plans.order('created_at desc').paginate(:page => params[:page], :per_page => 10)
    @title = "#{@user.login}的任务认领"
    render 'see_all'
  end
  
  def following_venues
    @items = @user.venue_followings.map(&:followable).paginate(:page => params[:page], :per_page => 10)
    @title = "#{@user.login}关注的地点"
    render 'see_all'
  end
  
  def following_users
    @items = @user.user_followings.map(&:followable).paginate(:page => params[:page], :per_page => 10)
    @title = "#{@user.login}关注的用户"
    render 'see_all'
  end

  def followers
    @items = @user.followers.paginate(:page => params[:page], :per_page => 10)
    @title = "关注#{@user.login}的用户"
    render 'see_all'
  end
  
  def following_tasks
    @items = @user.task_followings.map(&:followable).paginate(:page => params[:page], :per_page => 10)
    @title = "#{@user.login}关注的活动"
    render 'see_all'
  end

  def reset_password
    @user = User.where(:login => params[:login],:email => params[:email]).first
    if @user.present?
      @user.reset_password!
      flash[:dialog] = "<a href=#{reset_completed_users_path(:email => @user.email)} class='open_dialog' title='重置密码的邮件已发送'>重置密码的邮件已发送</a>"
      redirect_to root_path
    else
      flash[:error] = "用户名和邮箱不正确或不存在"
      redirect_to reset_password_path
    end
  end
  
  def reset_completed
    @email = params[:email]
    render :layout => false if params[:layout] == 'false'
  end
  
  def more_timeline
    @timeline = @user.events.paginate(:page => params[:page], :per_page => 10)
    render '/public/more_timeline',:layout => false
  end
  
  def more_questions
    @items = @user.questions.paginate(:page => params[:page], :per_page => 10)
    render '/public/more_items',:layout => false
  end
  
  def more_answers
    @items = @user.answers.paginate(:page => params[:page], :per_page => 10)
    render '/public/more_items',:layout => false
  end
  
  private
  def find_user
    @user = User.find(params[:id])    
  end
end
