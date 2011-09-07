class VotesController < ApplicationController
  before_filter :login_required
  respond_to :html, :js, :xml  
  def index
    redirect_to :back
  end 
  
  def show
    redirect_to :back
  end 

  def create
    @vote = Vote.new(:user_id => current_user.id)
    @vote.voteable_id = params[:voteable_id]
    @vote.voteable_type = params[:voteable_type]
    @vote.positive = params[:positive].present?
    @voteable = @vote.voteable
    @voteable.votes << @vote
    respond_to do |format|
      format.html {redirect_to params[:back_path] || :back}
      format.js { render 'create'} 
    end
  end
  
  def destroy
    @vote = current_user.votes.find(params[:id])
    @vote.destroy
    redirect_to :back
  end
end
