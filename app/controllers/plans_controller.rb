class PlansController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_plan, :except => [:index,:new,:create]
  
  def create
    @plan = Plan.new(params[:plan])
    @plan.requirement = Requirement.find(params[:requirement_id])
    @plan.venue = @plan.requirement.venue
    @plan.action = @plan.requirement.action
    @plan.user = current_user
    @plan.save
    redirect_to @plan.requirement
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
