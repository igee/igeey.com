class CommentsController < ApplicationController
  before_filter :login_required
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    @comment.save
    redirect_to :back
  end
  
end
