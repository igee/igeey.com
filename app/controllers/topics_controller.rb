class TopicsController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_topic, :except => [:index,:new,:create]
  after_filter  :clean_unread, :only => [:show]
  
  def index
    @topics = Topic.public.paginate(:page => params[:topics_page], :per_page => 20)
    @my_topics = (current_user.comments.where(:commentable_type => 'Topic').map(&:commentable) | current_user.topics).uniq.sort{|x,y| y.created_at <=> x.created_at} if current_user
  end
  
  def new
    @topic = Topic.new(:forumable_id => params[:forumable_id],:forumable_type => params[:forumable_type])
    render :layout => false if params[:layout] == 'false'
  end
  
  def create
    @topic = current_user.topics.build(params[:topic])
    @topic.last_replied_at = Time.now
    @topic.save
    respond_with @topic
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
  
  def clean_unread
    @topic.update_attribute(:has_new_comment,false) if @topic.user == current_user && @topic.has_new_comment
    @topic.comments.where(:user_id => current_user.id).map{|a| a.update_attribute(:has_new_comment,false)} if logged_in? == @topic.comments.where(:user_id => current_user.id).first.present?
  end

end
