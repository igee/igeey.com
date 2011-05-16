class NotificationsController < ApplicationController
  before_filter :login_required
  respond_to :html, :js
  
  def index
    @notifications = current_user.get_notifications
  end
  
  def destroy
    @notification = Notification.find(params[:id])
    @notification.read
    redirect_to @notification.notifiable
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
  
  def redirect_clear
    @notification = Notification.where(:user_id=>current_user.id, :notifiable_id=>params[:id], 
                                        :notifiable_type=>params[:type]).first
    unless @notification.nil?
      redirect_to clear_notification_path(@notification)
    else
      render :text=>'false'
    end
  end
  
end

