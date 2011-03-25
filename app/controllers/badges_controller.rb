class BadgesController < ApplicationController
  respond_to :html
    
  before_filter :login_required
  before_filter :admin_required,:only => [:index,:edit,:update]
  after_filter  :clean_unread,:only => [:get_badges]
  
  
  def get_badges
    @badges = current_user.grants.where(:unread => true).map(&:badge)
    render :layout => false
  end
  
  def index
    @badges = Badge.all
  end
  
  def edit
    @badge = Badge.find(params[:id])
    render :layout => false if params[:layout] == 'false'
  end
  
  def update
    @badge = Badge.find(params[:id])
    @badge.update_attributes(params[:badge])
    redirect_to badges_path
  end
  
  private
  
  def clean_unread
    current_user.grants.where(:unread => true).map{|g| g.update_attribute(:unread,false)} if logged_in?
  end
  
  def admin_required
    redirect_to root_path unless logged_in? && current_user.is_admin
  end
    
end
