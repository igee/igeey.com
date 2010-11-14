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
      render :select_action
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
    @record = Record.new(:action => @action,:venue => @venue,:calling => @calling,:plan => @plan)
  end
  
  def create
    @record = current_user.records.build(params[:record])
    if @record.save
      @oauth_message = "(这是oauth同步测试）我#{@record.description}  #{record_url(@record)}"
      current_user.send_to_miniblogs( @oauth_message,
                                      :to_douban => (@record.sync_to_douban && current_user.douban?),
                                      :to_sina => (@record.sync_to_douban && current_user.sina?)
                                      )
    end  
    respond_with(@record)
  end
  
  def show
    @venue = @record.venue
    @action = @record.action
    @calling = @record.calling
    @comment = Comment.new
    @comments = @record.comments
    @photo = Photo.new
    @photos = @record.photos
  end
  
  def select_venue
    
  end
  
  private
  def find_record
    @record = Record.find(params[:id])
  end
  
  def clean_unread
    @record.update_attribute(:has_new_comment,false) if @record.user == current_user && @record.has_new_comment
  end
end
