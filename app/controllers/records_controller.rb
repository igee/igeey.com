class RecordsController < ApplicationController
  respond_to :html,:json
  before_filter :login_required, :except => [:index,:show]
  before_filter :find_record, :except => [:index,:new,:create,:find_by_tag]
  
  def new
    @record = current_user.records.build(:venue_id => params[:venue_id],:plan_id => params[:plan_id])
    if @record.plan.nil?
      render :select_action, :layout =>  !(params[:layout] == 'false')
    elsif @record.plan.present?
      @record = Record.new(:venue => @record.plan.venue,:task => @record.plan.task,:plan => @record.plan)
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
    @task = @record.task
    @comments = @record.comments
    @photos = @record.photos
  end
  
  def edit
  end
  
  def update
    @record.update_attributes(params[:record]) if @record.owned_by?(current_user)
    if params[:back_path].present?
      redirect_to params[:back_path]
    else
      respond_with @record
    end
  end
  
  def destroy
    @record.destroy  if @record.owned_by?(current_user)
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
