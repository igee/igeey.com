class NotificationsController < ApplicationController
  before_filter :login_required
  respond_to :html, :js
  
  def show
    @notifications = Notification.get_unread_by_user_id(current_user.id)
  end
  
  def read
    @notifiable = params[:type].constantize.find(params[:id].to_i)
    Notification.delete(current_user.id, @notifiable)
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {render_text "ok"}
    end
  end
end
