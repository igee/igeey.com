class RecordsController < ApplicationController
  respond_to :html,:json
  before_filter :login_required, :except => [:index,:show]
  before_filter :find_record, :except => [:index,:new,:create,:find_by_tag]
  
  def index
    @actions = Action.callable
  end
  
  def new
    @record = current_user.records.build(:action_id => params[:action_id],:venue_id => params[:venue_id],:plan_id => params[:plan_id])
    if @record.action.nil? && @record.plan.nil?
      @actions = Action.callable
      render :select_action, :layout =>  !(params[:layout] == 'false')
    elsif @record.plan.present?
      @record = Record.new(:action => @record.plan.action,:venue => @record.plan.venue,:calling => @record.plan.calling,:plan => @record.plan,:unit => @record.plan.calling.unit)
    end    
  end
  
  def create
    @record = current_user.records.build(params[:record])
    @record.photos.map{|p| p.user_id = current_user.id}
    @record.save
    respond_with(@record)
  end
  
  def show
    @venue = @record.venue
    @action = @record.action
    @calling = @record.calling
    @project = @record.project
    @comments = @record.comments
    @photos = @record.photos
  end
  
  def edit
  end
  
  def update
    @record.update_attributes(params[:record]) if @record.user_id == current_user.id
    if params[:back_path].present?
      redirect_to params[:back_path]
    else
      respond_with @record
    end
  end
  
  def destroy
    @record.destroy  if @record.user_id == current_user.id
    if params[:back_path].present?
      redirect_to params[:back_path]
    else
      respond_with @record
    end
  end
    
  def select_venue
  end
  
  def find_by_tag
    @records = Record.find_tagged_with(params[:tag])
    respond_with @records
  end
  
  private
  def find_record
    @record = Record.find(params[:id])
  end
  
end
