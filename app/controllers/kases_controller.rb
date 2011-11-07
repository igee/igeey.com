class KasesController < ApplicationController
  respond_to :html,:json
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_solution
  before_filter :check_permission, :only => [:destroy,:update]
  
  def index
    @kases = @problem.kases
    render :layout => false if params[:layout] == 'false'
  end
  
  def new
    @kase = @solution.kases.build
  end
  
  def create
    @kase = @solution.kases.build(params[:kase])
    @kase.user_id = current_user.id
    if @kase.save
      redirect_to solution_path(@solution)
    else
      render :action => 'new'
    end
  end
  
  def update
    @kase.update_attributes(params[:kase])
    redirect_to "#{problem_path(@problem)}/kases/#{@kase.id}"
  end
  
  def destroy
    @kase.destroy
    redirect_to problem_path(@problem)
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
  def find_solution
    @solution = Solution.find(params[:solution_id])
  end
  
  def check_permission
    @kase = Kase.find(params[:id])
    redirect_to :back unless @kase.owned_by?(current_user)
  end
end
