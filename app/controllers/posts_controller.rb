class PostsController < ApplicationController
  before_filter :find_problem
  before_filter :login_required, :except => [:index, :show]
  
  def new
    @post = @problem.posts.build
  end
  
  def create
    @post = @problem.posts.build(params[:post])
    @post.user_id = current_user.id
    if @post.save
      redirect_to problem_path(@problem)
    else
      render :action => 'new'
    end
  end

  private
  def find_problem
    @problem = Problem.find(params[:problem_id])
  end
end
