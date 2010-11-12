class PlansController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index, :show]
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
    @plan.save
    if @plan.save
      @oauth_message = "(这是oauth同步测试）： 我要#{@plan.description}  #{calling_plan_url(@plan.calling,@plan)}"
      current_user.send_to_miniblogs( @oauth_message,
                                      :to_douban => (@plan.sync_to_douban && current_user.douban?),
                                      :to_sina => (@plan.sync_to_douban && current_user.sina?)
                                      )
    end
    redirect_to @plan.calling
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
    @photos = @calling.photos
    @photo = Photo.new
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
    
  private
  def find_plan
    @plan = Plan.find(params[:id])
  end
  
  def clean_unread
    @plan.update_attribute(:has_new_comment,false) if @plan.user == current_user
  end
end
