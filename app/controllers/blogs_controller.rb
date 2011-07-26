class BlogsController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:show]
  
  def new
    @blog = Blog.new()
  end
  
  def create
    @blog = Blog.new(params[:blog])
    @blog.save
    respond_with @blog
  end
  
  def show
    @blog = Blog.find(params[:id])
  end
end