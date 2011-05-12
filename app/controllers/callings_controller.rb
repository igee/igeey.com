class CallingsController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index, :show,:progress]
  before_filter :find_calling, :except => [:index, :new, :create]
  
  def create
    @calling = current_user.callings.build(params[:calling])
    puts params[:calling]
    if @calling.save
      flash[:dialog] = "<a href='#{new_sync_path}?syncable_type=#{@calling.class}&syncable_id=#{@calling.id}' class='open_dialog' title='传播这个行动'>同步</a>" 
    end
    respond_with @calling
  end

  def show
    @calling = Calling.find(params[:id])
    @venue = @calling.venue
    @plans = @calling.plans.undone
    @records = @calling.records
    @my_plan = @plans.select{|p| p.user_id == current_user.id}.first if logged_in? # user`s plan on this calling
    @my_record = @records.select{|r| r.user_id == current_user.id}.first if logged_in? # user`s record on this calling
    @followers = @calling.followers
    @comments = @calling.comments
    @photos = @calling.photos
  end
  
  def update
    @calling.update_attributes(params[:calling])
    if params[:back_path].present?
      redirect_to params[:back_path]
    else
      respond_with @calling
    end
  end
  
  def close
    @calling.update_attributes(:close => true) if @calling.owned_by?(current_user)
    respond_with @calling
  end
  
  def progress
    @records = @calling.records
  end
  
  def more
    @items = Calling.paginate(:page => params[:page], :per_page => 6)
    render '/public/more_items',:layout => false
  end
  
  private
  def find_calling
    @calling = Calling.find(params[:id])
  end
  
end
