class FeedbacksController < ApplicationController
  def new
    @feedback = Feedback.new
    render :layout => false if params[:layout] == 'false'
  end
  
  def create
    @feedback = Feedback.new(params[:feedback])
    flash[:dialog] = "<a href=#{thanks_feedbacks_path} class='open_dialog' title='感谢'>感谢</a>"
    redirect_to :back
  end
  
  def index
    @feedbacks = Feedback.paginate(:page => params[:page], :per_page => 20)
  end
  
  def thanks
    render :layout => false
  end
  
end
