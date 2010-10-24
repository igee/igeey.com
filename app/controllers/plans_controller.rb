class PlansController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_plan, :except => [:index,:new,:create]
  after_filter :clean_unread, :only => [:show]
  
  def new
    @requirement = Requirement.find(params[:requirement_id])
    @plan = @requirement.plans.build()
    if params[:layout] == 'false'
      render :layout => false
    end  
  end
  
  def create
    @plan = Plan.new(params[:plan])
    @plan.requirement = Requirement.find(params[:requirement_id])
    @plan.venue = @plan.requirement.venue
    @plan.action = @plan.requirement.action
    @plan.user = current_user
    @plan.save
    if @plan.save
      @oauth_message = "(这是oauth同步测试）： 我要#{@plan.description}  #{requirement_plan_url(@plan.requirement,@plan)}"
      if @plan.sync_to_douban && current_user.douban?
        current_user.send_to_douban_miniblog(@oauth_message)
      end
    end
    redirect_to @plan.requirement
  end
  
  def edit
  end
  
  def update
  end
  
  def show
    @requirement = @plan.requirement
    @comment = Comment.new
    @comments = @plan.comments
  end
  
  def destroy
    @plan.destroy
    redirect_to @plan.requirement
  end
    
  private
  def find_plan
    @plan = Plan.find(params[:id])
  end
  
  def clean_unread
    @record.update_attribute(:has_new_comment,false) if @record.user = current_user
  end
end
