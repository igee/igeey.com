class RequirementsController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index, :show]
   
  def index
    @requirements = Requirement.all
  end

  def show
    @requirement = Requirement.find(params[:id])
    @venue = @requirement.venue
    @action = @requirement.action
    @plans = @requirement.plans
    @records = @requirement.records
  end

  def new
    @requirement = Requirement.new(:venue_id => params[:venue_id],:action_id => params[:action_id])
    @venue = @requirement.venue
    @action = @requirement.action
    respond_with @requirement
  end

  def edit
    @requirement = Requirement.find(params[:id])
  end

  def create
    @requirement = Requirement.new(params[:requirement])
    @requirement.publisher = current_user
    @requirement.save
    respond_with @requirement
  end

  def update
    @requirement = Requirement.find(params[:id])
    respond_with @requirement
  end

  def destroy
    @requirement = Requirement.find(params[:id])
    @requirement.destroy
    respond_with @requirement
  end
end
