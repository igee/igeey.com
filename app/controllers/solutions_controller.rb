class SolutionsController < ApplicationController
  before_filter :login_required, :except => [:index]
  before_filter :find_problem
  
  def index
    @solutions = @problem.solutions
  end
  
  def new
    @solution = @problem.solutions.build
  end
  
  def show
    @solution = Solution.find(params[:id])
  end
  
  def create
    @solution = @problem.solutions.build(params[:solution])
    if @solution.save
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
