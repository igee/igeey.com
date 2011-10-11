class PostsController < ApplicationController
  respond_to :html
  before_filter :find_solution
  
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
    @post = @solution.posts.build
  end
  
  def create
    @post = @solution.posts.build(params[:post])
    @post.user_id = current_user.id
    if @post.save
      @post.update_attributes(:last_replied_at=>@post.created_at)
      redirect_to solution_post_path(@solution, @post)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    @post.update_attributes(params[:post]) if @post.owned_by?(current_user)
    if params[:back_path].present?
      redirect_to params[:back_path]
    else
      redirect_to solution_post_path(@solution, @post)
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy if @post.owned_by?(current_user)
    if params[:back_path].present?
      redirect_to params[:back_path]
    else
      redirect_to @solution
    end
  end
  
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
  end

  private
  def find_solution
    @solution = Solution.find(params[:solution_id])
  end
end
