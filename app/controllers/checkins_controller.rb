class CheckinsController < ApplicationController
  before_filter :login_required
  def create
    @checkin = current_user.checkins.build(params[:checkin])
    @checkin.save
    redirect_to @checkin.venue
  end

end
