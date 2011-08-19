class KasesController < ApplicationController
  respond_to :html,:json
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_problem
  before_filter :check_permission, :only => [:destroy,:update]
  
  def index
    @kases = @problem.kases
    render :layout => false if params[:layout] == 'false'
  end
  
  def new
    @kase = @problem.kases.build
  end
  
  def create
    @kase = @problem.kases.build(params[:kase])
    if @kase.save
      flash[:dialog] = "<a href='#{new_sync_path}?syncable_type=#{@kase.class}&syncable_id=#{@kase.id}' class='open_dialog' title='传播这个案例'>同步</a>"
      redirect_to problem_path(@problem)
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
  def find_problem
    @problem = Problem.find(params[:problem_id])
  end
  
  def check_permission
    @kase = Kase.find(params[:id])
    redirect_to :back unless @kase.owned_by?(current_user)
  end
end
