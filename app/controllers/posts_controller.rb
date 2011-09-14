class PostsController < ApplicationController
  respond_to :html
  before_filter :find_problem
  before_filter :login_required, :except => [:index, :show]
  
  def index
    @tag = Tag.find_by_name(params[:tag_name])
    @sort = params[:sort_by]
    if @tag.nil?
      @posts = @problem.posts
    else
      @posts = @tag.taggeds.where(['taggable_type = ?','Post']).map(&:taggable).sort_by(&:offset_count).reverse
    end
    if @sort == 'time'
      @posts = @posts.sort_by(&:created_at).reverse
    end
    render :layout => false
  end
  
  def new
    @post = @problem.posts.build
  end
  
  def create
    @post = @problem.posts.build(params[:post])
    @post.url = 'http://' + @post.url if (/http:\/\//.match(@post.url).nil? && /https:\/\//.match(@post.url).nil?)
    @post.user_id = current_user.id
    @post.url_host = @post.get_url_host
    if @post.save
      redirect_to problem_path(@problem)
    else
      render :action => 'new'
    end
  end
  
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
  end

  private
  def find_problem
    @problem = Problem.find(params[:problem_id])
  end
end
