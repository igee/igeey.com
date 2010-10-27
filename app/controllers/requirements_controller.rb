class RequirementsController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_requirement, :except => [:index, :new, :create]
  after_filter :clean_unread, :only => [:show]
   
  def index
    @requirements = Requirement.all
  end

  def show
    @requirement = Requirement.find(params[:id])
    @venue = @requirement.venue
    @action = @requirement.action
    @plans = @requirement.plans.select{|p| p.record.nil?}
    @records = @requirement.records
    @plan = @plans.select{|p| p.user == current_user}.first  # user`s plan on this requirement
    @record = @records.select{|r| r.user == current_user}.first # user`s record on this requirement
    @comment = Comment.new
    @comments = @requirement.comments
    @photo = Photo.new
    @photos = @requirement.photos.limit(3)
  end

  def new
    @requirement = current_user.requirements.build(:venue_id => params[:venue_id],:action_id => params[:action_id])
    @venue = @requirement.venue
    @action = @requirement.action
    respond_with @requirement
  end

  def edit
    @requirement = Requirement.find(params[:id])
  end

  def create
    @requirement = current_user.requirements.build(params[:requirement])
    if @requirement.save
      @oauth_message = "(这是oauth同步测试）我在爱聚网站发布了新的公益需求： #{@requirement.description}  #{requirement_url(@requirement)}"
      if @requirement.sync_to_douban && current_user.douban?
        current_user.send_to_douban_miniblog(@oauth_message)
      end
    end  
    respond_with @requirement
  end

  def update
    @requirement.update_attributes(params[:requirement])
    respond_with @requirement
  end

  def destroy
    @requirement.destroy
    respond_with @requirement
  end
  
  private
  def find_requirement
    @requirement = Requirement.find(params[:id])
  end
  
  def clean_unread
    @requirement.update_attribute(:has_new_comment,false) if @requirement.publisher == current_user
  end
  
end
