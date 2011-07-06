class ProblemsController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:show, :index]
  before_filter :find_problem, :except => [:new,:create,:index]
  
  def index
    @problems = Problem.all
  end
  
  def new
    @problem = Problem.new
  end
  
  def create
    @problem = Problem.new(params[:problem])
    @problem.save
    respond_with @problem
  end
  
  def show
    @case = Case.new
    @cases = @problem.cases
    @comments = @problem.comments
  end
  
  private
  def find_problem
    @problem = Problem.find(params[:id])
  end
end
