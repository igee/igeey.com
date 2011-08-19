class BlogsController < ApplicationController
  respond_to :html, :rss
  before_filter :login_required, :except => [:show,:index]
  before_filter :find_blog,      :except => [:create,:new,:index]
  before_filter :check_admin,    :except => [:show,:index]
  
  def index
    @blogs = Blog.all
    @problems = Problem.where(:id => INDEX_PROBLEMS['problem_ids'].split(','))
  end
  
  def new
    @blog = Blog.new()
  end
  
  def create
    @blog = Blog.new(params[:blog])
    @blog.save
    respond_with @blog
  end
  
  def show
    @comments = @blog.comments
    @problem_ids = INDEX_PROBLEMS['problem_ids'].split(',')
  end
  
  def edit
  end
  
  def update
    @blog.update_attributes(params[:blog])
    if params[:back_path].present?
      redirect_to params[:back_path]
    else
      respond_with @blog
    end
  end
  
  def destroy
    @blog.destroy
    redirect_to :back
  end
  
  private
  
  def find_blog
    if /^[\d]*$/.match(params[:id])
      @blog = Blog.find(params[:id])
    else
      @blog = Blog.find_by_en_title(params[:id])
    end
    render :file => "public/404.html",:status => 404,:layout => false if @blog.nil?
  end
end
