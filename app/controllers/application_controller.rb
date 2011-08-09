class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  protect_from_forgery
  
  private
  
  def check_admin
    redirect_to :root unless (current_user && current_user.is_admin?)
  end
end
