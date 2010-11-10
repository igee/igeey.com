class TopicsController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_topic, :except => [:index,:new,:create]
  
  def index
    @topics = Topic.all
  end
  
  def new
    @topic = Topic.new
  end
  
  def create
    @topic = current_user.topics.build(params[:topic])
    @topic.last_replied_at = Time.now
    @topic.save
    respond_with @topic
  end
  
  def edit
  end
  
  def show
    @comments = @topic.comments
    @comment = Comment.new
  end
  
  private
  def find_topic
    @topic = Topic.find(params[:id])
  end

end
