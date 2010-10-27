class RecordsController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index,:show]
  before_filter :find_record, :except => [:index,:new,:create]
  after_filter :clean_unread, :only => [:show]
  
  def new    
    @record = current_user.records.build(:action_id => params[:action_id],:venue_id => params[:venue_id],:plan_id => params[:plan_id])
    @plan = @record.plan
    @requirement = @plan.nil? ? @record.requirement : @plan.requirement
    @venue = @requirement.nil? ? @record.venue : @requirement.venue
    @action = @requirement.nil? ? @record.action : @requirement.action
    @record = Record.new(:action => @action,:venue => @venue,:requirement => @requirement,:plan => @plan)
    if @venue.nil? 
      @venues = Venue.all
      render "select_venue"
    end    
  end
  
  def create
    @record = current_user.records.build(params[:record])
    if @record.save
      @oauth_message = "(这是oauth同步测试）我#{@record.description}  #{record_url(@record)}"
      if @record.sync_to_douban && current_user.douban?
        current_user.send_to_douban_miniblog(@oauth_message)
      end
    end  
    respond_with(@record)
  end
  
  def show
    @venue = @record.venue
    @action = @record.action
    @requirement = @record.requirement
    @comment = Comment.new
    @comments = @record.comments
    @photo = Photo.new
    @photos = @record.photos
  end
  
  private
  def find_record
    @record = Record.find(params[:id])
  end
  
  def clean_unread
    @record.update_attribute(:has_new_comment,false) if @record.user = current_user
  end
end
