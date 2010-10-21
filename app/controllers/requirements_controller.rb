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
    @plan = @plans.where(:user_id => (current_user.id if current_user)).first || nil
    @record = @records.where(:user_id => (current_user.id if current_user)).first || nil
    @records = (@requirement.records - [@record])
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
    if @requirement.save
      @oauth_message = "(这是oauth同步测试）我在爱聚网站发布了新的公益需求： #{@requirement.description}  #{requirement_url(@requirement)}"
      if @requirement.sync_to_douban && current_user.douban?
        current_user.send_to_douban(@oauth_message)
      end
    end  
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
