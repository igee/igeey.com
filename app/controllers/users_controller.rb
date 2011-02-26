class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  # include AuthenticatedSystem
  respond_to :html
  before_filter :login_required, :only=> [:edit,:setting]
  before_filter :find_user, :except => [:new,:create,:edit,:setting,:welcome,:index,:reset_password,:reset_completed]

  # render new.rhtml
  def new
    redirect_to :root if logged_in?
    @user = User.new
    render :layout => false if params[:layout] == 'false'
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
    @records = @user.records.limit(7)
    @callings = @user.callings.limit(7)
    @sayings = @user.sayings.limit(7)
    @plans = @user.plans.undone.limit(7)
    @followers = @user.followers.limit(9)
    @following_users = @user.user_followings.limit(9).map(&:followable)
    @following_venues = @user.venue_followings.limit(7).map(&:followable)
    @photos = @user.photos.limit(13)
    @badges = @user.grants.limit(9).map(&:badge)
  end
  
  def following_venues
    @following_venues = @user.venue_followings.map(&:followable)
  end
  
  def following_users
    @following_users = @user.user_followings.map(&:followable)
  end

  def following_callings
    @following_callings = @user.calling_followings.map(&:followable)
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
  
  def more_items
    @items = eval({:badges => '@user.grants[8..-1].map(&:badge)',
                   :followers => '@user.followers[8..-1]',
                   :following_users => "@user.user_followings[8..-1].map(&:followable)",
                   :following_venues => '@user.venue_followings[8..-1].map(&:followable)',
                   :photos => "@user.photos.paginate(:page => #{params[:page]}, :per_page => 13)",
                   :callings => "@user.callings.paginate(:page => #{params[:page]}, :per_page => 6)",
                   :sayings => "@user.sayings.paginate(:page => #{params[:page]}, :per_page => 6)",
                   :records => "@user.records.paginate(:page => #{params[:page]}, :per_page => 6)",
                   :plans => "@user.plans.paginate(:page => #{params[:page]}, :per_page => 6)",
                   }[params[:items].to_sym])
    render :layout => false
  end
  
  private
  def find_user
    @user = User.find(params[:id])    
  end
end
