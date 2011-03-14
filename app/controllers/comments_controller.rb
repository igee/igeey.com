class CommentsController < ApplicationController
  before_filter :login_required
  respond_to :html, :js, :xml  
  def create
    @comment = current_user.comments.new(params[:comment])
    @comment.content = @comment.content
    @comment.save
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {respond_with @comment}
    end
  end
  
  def more
    @commentable = (params[:commentable_type]).capitalize.constantize.find(params[:commentable_id])
    @comments = @commentable.comments
    respond_to do |format|
      format.js {respond_with @comments}
    end
  end
end
