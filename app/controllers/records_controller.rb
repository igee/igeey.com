class RecordsController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_record, :except => [:index,:new,:create]
  
  def new
    @record = Record.new(:action_id => params[:action_id],:venue_id => params[:venue_id],:requirement_id => params[:requirement_id])
    @requirement = @record.requirement
    @venue = @requirement.nil? ? @record.venue : @requirement.venue
    @action = @requirement.nil? ? @record.action : @requirement.action
    @record = Record.new(:action => @action,:venue => @venue,:requirement => @requirement)
    if @venue.nil? 
      @venues = Venue.all
      render "select_venue"
    end
    
  end
  
  def create
    @record = Record.new(params[:record])
    @record.user = current_user
    flash[:notice] = 'Record was successfully created.' if @record.save
    respond_with(@record)
  end
  
  def show
    @venue = @record.venue
    @action = @record.action
    @requirement = @record.requirement
  end
  
  private
  def find_record
    @record = Record.find(params[:id])
  end
  
end
