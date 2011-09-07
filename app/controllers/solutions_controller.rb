class SolutionsController < ApplicationController
  respond_to :html
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
    @comments = @solution.comments
  end
  
  def create
    @solution = @problem.solutions.build(params[:solution])
    @solution.user = current_user
    @solution.save
    respond_with @problem
  end
  
  private
  def find_problem
    @problem = Problem.find(params[:problem_id])
  end
end
