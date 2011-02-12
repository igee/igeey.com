class CheckinsController < ApplicationController
  before_filter :login_required
  def create
    @checkin = current_user.checkins.build(params[:checkin])
    @checkin.last_replied_at = Time.now
    @checkin.last_replied_user_id = @checkin.user_id
    @checkin.save
    redirect_to @checkin.venue
  end

end
