class DoingsController < ApplicationController
  before_filter :login_required
  def create
    @doing = current_user.doings.build(params[:doing])
    @doing.save
    redirect_to @doing.venue
  end
  
  def destroy
    @doing = Saying.find(params[:id])
    @doing.destroy if @doing.user_id == current_user.id
    if params[:back_path].present?
      redirect_to params[:back_path]
    else
      respond_with @doing
    end
  end
end
