class NotificationsController < ApplicationController
  before_filter :login_required
  respond_to :html, :js
  
  def index
    @notifications = Notification.get_unread_by_user_id(current_user.id)
  end
  
  def destroy
    @notification = Notification.find(params[:id])
    @notification.read
    redirect_to eval("#{@notification.notifiable_type.downcase}_path(#{@notification.notifiable_id})")
  end
  
  def clear
    @notification = Notification.find(params[:id])
    @notification.read
    render :text=>'true'
  end
  
  def clear_all
    Notification.where(:user_id=>current_user.id).each do |n|
      n.read
    end
    redirect_to :root
  end
end

