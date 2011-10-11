class SolutionsController < ApplicationController
  respond_to :html
  before_filter :find_solution, :except => [:index,:new,:create]
  before_filter :check_manager, :only => [:edit, :update]
  
  def index
    @solutions = Solution.all
  end
  
  def new
    @solution = Solution.new
  end
  
  def edit 
  end

  def show
    @management = @solution.managements.build()
    @posts = @solution.posts
    @following_users = @solution.followers
    @managers = @solution.managers
  end
  
  def update
    @solution.update_attributes(params[:solution])
    @solution.save
    respond_with @solution
  end

  def create
    @solution = Solution.new(params[:solution])
    @solution.user = current_user
    @solution.save
    respond_with @solution
  end
  
  private
  def find_solution
    @solution = Solution.find(params[:id])
  end
  
  def check_manager
    unless current_user && @solution.managed_by?(current_user)
      render :text => '请用管理员登录后进入'
    end
  end
end
