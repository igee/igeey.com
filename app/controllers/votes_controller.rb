class VotesController < ApplicationController
  before_filter :login_required
  
  def create
      @vote = Vote.new(:user_id => current_user.id)
      @vote.voteable_id = params[:voteable_id]
      @vote.voteable_type = params[:voteable_type]
      @voteable = @vote.voteable
      if current_user.has_voted_to?(@voteable)
        render :text => "done"
      else
        @voteable.votes << @vote
        render :text => "喜欢(#{@voteable.class.find(@vote.voteable_id).votes_count})"
      end
  end
end