class CommentsController < ApplicationController
  before_filter :login_required, :except => [:more]
  respond_to :html, :js, :xml  
  def create
    @comment = current_user.comments.new(params[:comment])
    @comment.user_id = 1 if params[:offcial] && current_user.is_admin #user_id = 1 => offcial
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
      format.html {respond_with @comments}
      format.js {respond_with @comments}
    end
  end
end
