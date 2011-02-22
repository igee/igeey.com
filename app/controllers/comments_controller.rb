class CommentsController < ApplicationController
  before_filter :login_required
  def create
    @comment = current_user.comments.new(params[:comment])
    @comment.content = @comment.content
    @comment.save
    redirect_to :back
  end
end
