# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  # include AuthenticatedSystem
  
  def show
    redirect_to :root
  end
  # render new.rhtml
  def new
    redirect_to :root if logged_in?
    if params[:layout] == 'false'
      session[:return_to] = :back
      render :layout => false
    end  
  end
  
  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      render_component :controller => session[:controller],:action => session[:action],:params => session[:params]

    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    redirect_back_or_default('/', :notice => "You have been logged out.")
  end
  
  def reset_password
    render :layout => false if params[:layout] == 'false'
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash.now[:error] = "用户名(或邮箱)和密码不匹配"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
