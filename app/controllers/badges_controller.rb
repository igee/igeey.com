class BadgesController < ApplicationController
  before_filter :login_required
  #after_filter  :clean_unread
  
  
  def get_badges
    @badges = current_user.grants.where(:unread => true).map(&:badge)
    render :layout => false
  end
  
  private
  def find_calling
    @calling = Calling.find(params[:id])
  end
  
  def clean_unread
    current_user.grants.where(:unread => true).map{|g| g.update_attribute(:unread,false)}
  end
    
end
