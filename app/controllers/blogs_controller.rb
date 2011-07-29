class BlogsController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:show]
  before_filter :find_blog,      :except => [:create,:new]
  before_filter :check_admin,    :except => [:show]
  
  def new
    @blog = Blog.new()
  end
  
  def create
    @blog = Blog.new(:title=>params[:blog][:title],:en_title=>params[:blog][:en_title],:user_id=>params[:blog][:user_id],:content=>params[:editor01])
    @blog.save
    respond_with @blog
  end
  
  def show
    @blogs = Blog.all
  end
  
  def edit
  end
  
  def update
    @blog.update_attributes(:title=>params[:blog][:title],:en_title=>params[:blog][:en_title],:user_id=>params[:blog][:user_id],:content=>params[:editor01])
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
