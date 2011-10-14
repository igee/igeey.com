class BlogsController < ApplicationController
  respond_to :html, :rss
  before_filter :login_required, :except => [:show,:index]
  before_filter :find_blog,      :except => [:create,:new,:index]
  before_filter :find_solution
  
  def index
    @blogs = Blog.all
    @problems = Problem.published.limit(7).reverse
    @current_problems = @problems[3..6] 
    @prev_problems = @problems[0..2] 
  end
  
  def new
    @blog = @solution.blogs.build
  end
  
  def create
    @blog = @solution.blogs.build(params[:blog])
    if @blog.save
      redirect_to solution_blog_path(@solution, @blog)
    else
      render :action => 'new'
    end
  end
  
  def show
    @comments = @blog.comments
  end
  
  def edit
  end
  
  def update
    @blog.update_attributes(params[:blog])
    if params[:back_path].present?
      redirect_to params[:back_path]
    else
      respond_with solution_blog_path(@solution, @blog)
    end
  end
  
  def destroy
    @blog.destroy
    redirect_to :back
  end
  
  private
  
  def find_solution
    @solution = Solution.find(params[:solution_id])
  end
  
  def check_manager
    unless current_user && @solution.managed_by?(current_user)
      render :text => '请用管理员登录后进入'
    end
  end
  
  def find_blog
    if /^[\d]*$/.match(params[:id])
      @blog = Blog.find(params[:id])
    else
      @blog = Blog.find_by_slug(params[:id])
    end
    render :file => "public/404.html",:status => 404,:layout => false if @blog.nil?
  end
end
