class PlansController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_plan, :except => [:index,:new,:create]
  
  def new
    @plan = Plan.new(:requirement_id => params[:requirement_id])
  end
  
  def create
    @plan = Plan.new(params[:plan])
    @plan.user = current_user
    @plan.venue = @plan.requirement.venue
    @plan.action = @plan.requirement.action
    @plan.save
    respond_with @plan
  end
  
  def edit
  end
  
  def update
  end
  
  def show
    redirect_to @plan.requirement
  end
  
  private
  def find_plan
    @plan = Plan.find(params[:id])
  end
  
end
