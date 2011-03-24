class TopicsController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_topic, :except => [:index,:new,:create]
  
  def index
    
  end
  
  def new
    @topic = Topic.new(:venue_id => params[:venue_id])
    render :layout => false if params[:layout] == 'false'
  end
  
  def create
    @topic = current_user.topics.build(params[:topic])
    @topic.last_replied_at = Time.now
    @topic.save
    redirect_to :back
  end
  
  def edit
  end
  
  def update
  end
  
  def show
    @comments = @topic.comments
  end
  
  private
  def find_topic
    @topic = Topic.find(params[:id])
  end

end
