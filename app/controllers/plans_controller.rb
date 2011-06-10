class PlansController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index, :show,:redirect]
  before_filter :find_plan_and_task, :except => [:index,:new,:create]
  
  def index
    redirect_to task_path(@task)
  end
  
  def new
    @task = Task.find(params[:task_id])
    @venue = @task.venue
    @plan = @task.plans.build(:tag_list=>@task.tag_list)
    render :layout => false if params[:layout] == 'false'
  end
  
  def create
    @task = Task.find(params[:task_id])
    @plan = current_user.plans.build(params[:plan])
    @plan.task = @task
    if @plan.save
      respond_with @task
    else
      render :new
    end
    
  end
  
  def show
    @venue = @plan.venue
    @comments = @task.comments
    @followers = @task.followers
    @photos = @task.photos
    @records = @task.records
    @plans = @task.plans.undone
    @my_plan = current_user.plans.select{|p| p.task_id == @task.id}.first if logged_in?
  end
  
  def edit
  end
  
  def update
    @plan.update_attributes(params[:plan])  if @plan.owned_by?(current_user)
    if params[:back_path].present?
      redirect_to params[:back_path]
    else
      respond_with @plan
    end
  end
  
  def destroy  
    @plan.destroy if @plan.owned_by?(current_user)
    redirect_to :back
  end
    
  def duplicate
    @parent = Plan.find(params[:id])
    @plan = @task.plans.build(:parent_id => @parent.id,:plan_at => @task.do_at)
    if params[:layout] == 'false'
      render :action => 'new',:layout => false
    else
      render :action => 'new'
    end  
  end
  
  def redirect
    redirect_to task_plan_path(@plan.task,@plan)
  end
    
  private
  def find_plan_and_task
    begin 
      @plan = Plan.find(params[:id])
      @task = @plan.task
    rescue
      @plan = Plan.new
      @task = Task.find(params[:task_id])
      render :no_found
    end  
  end
  
end
