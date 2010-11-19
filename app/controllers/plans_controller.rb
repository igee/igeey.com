class PlansController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index, :show,:redirect]
  before_filter :find_plan, :except => [:index,:new,:create,:duplicate]
  after_filter  :clean_unread, :only => [:show]
  
  def new
    @calling = Calling.find(params[:calling_id])
    @plan = @calling.plans.build()
    if params[:layout] == 'false'
      render :layout => false
    end  
  end
  
  def create
    @plan = current_user.plans.build(params[:plan])
    @plan.calling = Calling.find(params[:calling_id])
    @plan.venue = @plan.calling.venue
    @plan.action = @plan.calling.action
    if @plan.save
      flash[:dialog] = "<a href='#{new_sync_path}?syncable_type=#{@plan.class}&syncable_id=#{@plan.id}' class='open_dialog' title='传播这个行动'>同步</a>" 
    end
    respond_with @plan
  end
  
  def edit
  end
  
  def update
  end
  
  def show
    @calling = @plan.calling
    @venue = @plan.venue
    @comment = Comment.new
    @comments = @calling.comments
    @followers = @calling.followers
    @photo = Photo.new
    @photos = @calling.photos
    @my_plan = @calling.plans.select{|p| p.user_id == current_user.id}.first if logged_in?
  end
  
  def destroy
    @plan.destroy
    redirect_to @plan.calling
  end
    
  def duplicate
    @calling = Calling.find(params[:calling_id])
    @parent = Plan.find(params[:id])
    @plan = @calling.plans.build(:parent_id => @parent.id)
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
  def find_plan
    @plan = Plan.find(params[:id])
  end
  
  def clean_unread
    @plan.update_attribute(:has_new_comment,false) if @plan.user == current_user && @plan.has_new_comment
  end
end
