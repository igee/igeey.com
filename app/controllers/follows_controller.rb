class FollowsController < ApplicationController
  before_filter :login_required,  :except => [:show]
  
  def show
    @follow = Follow.find(params[:id])
    redirect_to eval("#{@follow.followable.class.to_s.downcase}_path(#{@follow.followable.id})")
  end
  
  def create
    @follow = Follow.new(:user => current_user,:followable_type => params[:followable_type],:followable_id =>params[:followable_id])
    @follow.save
    redirect_to @follow.followable
  end
  
  def destroy
    @follow = current_user.followings.where(:id => params[:id]).first
    @follow.destroy if @follow.present?
    redirect_to :back
  end
end
