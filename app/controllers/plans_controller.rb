class PlansController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index, :show,:redirect]
  before_filter :find_plan_and_calling, :except => [:index,:new,:create]
  after_filter  :clean_unreads, :only => [:show]
  
  def index
    redirect_to calling_path(@calling)
  end
  
  def new
    @calling = Calling.find(params[:calling_id])
    @plan = @calling.plans.build(:plan_at => @calling.do_at)
    @plan.parent_id = params[:parent_id]
    render :layout => false if params[:layout] == 'false'
  end
  
  def create
    @calling = Calling.find(params[:calling_id])
    @plan = current_user.plans.build(params[:plan])
    @plan.calling = Calling.find(params[:calling_id])
    @plan.venue = @plan.calling.venue
    @plan.action = @plan.calling.action
    if @plan.save
      flash[:dialog] = "<a href='#{new_sync_path}?syncable_type=#{@plan.class}&syncable_id=#{@plan.id}' class='open_dialog' title='传播这个行动'>同步</a>" 
      respond_with [@calling,@plan]
    else
      render :new
    end
    
  end
  
  def show
    @venue = @plan.venue
    @comment = Comment.new
    @comments = @calling.comments
    @followers = @calling.followers
    @photos = @calling.photos
    @my_plan = @calling.plans.select{|p| p.user_id == current_user.id}.first if logged_in?
    render :layout => "no_sidebar"
  end
  
  def edit
  end
  
  def update
    @plan.update_attributes(params[:plan])  if @plan.user_id == current_user.id
    if params[:back_path].present?
      redirect_to params[:back_path]
    else
      respond_with @plan
    end
  end
  
  def destroy  
    @plan.destroy if @plan.user_id == current_user.id
    redirect_to :back
  end
    
  def duplicate
    @parent = Plan.find(params[:id])
    @plan = @calling.plans.build(:parent_id => @parent.id,:plan_at => @calling.do_at)
    if params[:layout] == 'false'
      render :action => 'new',:layout => false
    else
      render :action => 'new'
    end  
  end
  
  def redirect
    redirect_to calling_plan_path(@plan.calling,@plan)
  end
    
  private
  def find_plan_and_calling
    begin 
      @plan = Plan.find(params[:id])
      @calling = @plan.calling
    rescue
      @plan = Plan.new
      @calling = Calling.find(params[:calling_id])
      render :no_found
    end  
  end
  
  def clean_unreads
    @plan.update_attribute(:has_new_comment,false) if @plan.user == current_user && @plan.has_new_comment
    @plan.update_attribute(:has_new_child,false) if @plan.user == current_user && @plan.has_new_child
  end
end
