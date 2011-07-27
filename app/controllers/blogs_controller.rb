class BlogsController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:show]
  before_filter :find_blog,      :except => [:create,:new,:destroy]
  before_filter :check_admin,    :except => [:show]
  
  def new
    @blog = Blog.new()
  end
  
  def create
    @blog = Blog.new(params[:blog])
    @blog.save
    respond_with @blog
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    @blog.update_attributes(:title=>params[:blog][:title],:user_id=>params[:blog][:user_id],:content=>params[:editor01])
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
    @blog = Blog.find(params[:id])
  end
end