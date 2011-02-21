class SayingsController < ApplicationController
  before_filter :login_required
  def create
    @saying = current_user.sayings.build(params[:saying])
    @saying.last_replied_at = Time.now
    @saying.last_replied_user_id = @saying.user_id
    @saying.save
    redirect_to @saying.venue
  end

end
