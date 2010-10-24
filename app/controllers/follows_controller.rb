class FollowsController < ApplicationController
  before_filter :login_required
  
  def create
    @follow = Follow.new(:user => current_user,:followable_type => params[:followable_type],:followable_id =>params[:followable_id])
    @follow.save
    redirect_to :back
  end
  
  def destroy
    @follow = Follow.find(params[:id])
    @follow.destroy
    redirect_to :back
  end
end
