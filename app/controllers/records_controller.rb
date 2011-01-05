class RecordsController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index,:show]
  before_filter :find_record, :except => [:index,:new,:create]
  after_filter :clean_unread, :only => [:show]
  
  def index
    @actions = Action.all
  end
  
  def new
    @record = current_user.records.build(:action_id => params[:action_id],:venue_id => params[:venue_id],:plan_id => params[:plan_id])
    @plan = @record.plan
    
    if @plan.nil? && @record.action.nil?
      @actions = Action.all
      @venue = Venue.find(params[:venue_id])
      render :select_action, :layout =>  !(params[:layout] == 'false')
    end
    
    if @plan.nil? && @record.venue.nil?
      @action = Action.find params[:action_id]
      @following_venues = current_user.followings.where(:followable_type => 'Venue').map(&:followable)
      @city_venues = current_user.geo.venues if current_user.geo
      @all_venues = Venue.all
      render :select_venue
    end
    
    @calling = @plan.nil? ? @record.calling : @plan.calling
    @venue = @calling.nil? ? @record.venue : @calling.venue
    @action = @calling.nil? ? @record.action : @calling.action
    @unit = @calling.nil? ? '件' : @calling.unit
    @record = Record.new(:action => @action,:venue => @venue,:calling => @calling,:plan => @plan,:unit => @unit)
    @record.photos.build
  end
  
  def create
    @record = current_user.records.build(params[:record])
    @record.photos.map{|p| p.user_id = current_user.id}
    @record.save
    @record.photos.build if @record.photos.empty?
    respond_with(@record)
    
  end
  
  def show
    @venue = @record.venue
    @action = @record.action
    @calling = @record.calling
    @comment = Comment.new
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
  
  private
  def find_record
    @record = Record.find(params[:id])
  end
  
  def clean_unread
    @record.update_attribute(:has_new_comment,false) if @record.user == current_user && @record.has_new_comment
    @record.comments.where(:user_id => current_user.id).map{|a| a.update_attribute(:has_new_comment,false)} if logged_in? && @record.comments.where(:user_id => current_user.id).first.present?
  end
end
