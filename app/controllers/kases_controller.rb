class KasesController < ApplicationController
  respond_to :html,:json
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_problem
  
  def index
    @kases = @problem.kases
  end
  
  def new
    @kase = @problem.kases.build
  end
  
  def create
    @kase = @problem.kases.build(params[:kase])
    @kase.init_geocodding
    if @kase.save
      redirect_to problem_path(@problem)
    else
      render :action => 'new'
    end
  end
  
  def show
    @kase = Kase.find(params[:id])
    @problem_kase_ids = @problem.kases.map(&:id)
    @index = @problem_kase_ids.index(@kase.id)
    @prev = Kase.find( @problem_kase_ids[(@index-1) % @problem_kase_ids.size])
    @index != @problem.kases.length - 1 ? @next = Kase.find(@problem.kases[@index+1]) : @next = Kase.find(@problem.kases[0])
    @comments = @kase.comments
  end
  
  private
  def find_problem
    @problem = Problem.find(params[:problem_id])
  end
end
