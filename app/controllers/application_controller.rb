class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  protect_from_forgery
  
  private
  
  def check_admin
    current_user && current_user.is_admin?
  end
end
