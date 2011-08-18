class KasesController < ApplicationController
  respond_to :html,:json
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_problem
  
  def index
    @kases = @problem.kases
    render :layout => false if params[:layout] == 'false'
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
    @comments = @kase.comments
    @layout = params[:layout] != 'false'
    if @layout
      @problem_kase_ids = @problem.kases.map(&:id)
      @index = @problem_kase_ids.index(@kase.id)
      @prev = Kase.find( @problem_kase_ids[(@index-1) % @problem_kase_ids.size])
      @next = Kase.find( @problem_kase_ids[(@index+1) % @problem_kase_ids.size])
    else
      render :layout => false 
    end
  end
  
  private
  def find_problem
    @problem = Problem.find(params[:problem_id])
  end
end
