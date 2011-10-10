class SolutionsController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index]
  before_filter :find_solution, :except => [:index,:new,:create]
  
  def index
    @solutions = Solution.all
  end
  
  def new
    @solution = Solution.new
  end
  
  def edit 
  end

  def show
    @comments = @solution.comments
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
end
