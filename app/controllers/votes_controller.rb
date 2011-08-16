class VotesController < ApplicationController
  before_filter :login_required
  respond_to :html, :js, :xml  
  def index
    redirect_to :back
  end 
  
  def create
    @vote = Vote.new(:user_id => current_user.id)
    @vote.voteable_id = params[:voteable_id]
    @vote.voteable_type = params[:voteable_type]
    if @vote.voteable_type == 'Problem'
      @vote.is_agree = params[:is_agree]
    end
    @voteable = @vote.voteable
    @voteable.votes << @vote
    respond_to do |format|
      format.html {redirect_to params[:back_path] || :back}
      format.js { render 'create'} 
    end
  end
end
