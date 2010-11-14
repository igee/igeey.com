class CallingsController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_calling, :except => [:index, :new, :create,:next_step]
  after_filter  :clean_unread, :only => [:show]
   
  def index
    @callings = Calling.all
  end

  def show
    @calling = Calling.find(params[:id])
    @venue = @calling.venue
    @action = @calling.action
    @plans = @calling.plans.undone
    @records = @calling.records
    @my_plan = @plans.select{|p| p.user_id == current_user.id}.first if logged_in? # user`s plan on this calling
    @my_record = @records.select{|r| r.user_id == current_user.id}.first if logged_in? # user`s record on this calling
    @comment = Comment.new
    @comments = @calling.comments
    @photo = Photo.new
    @photos = @calling.photos.limit(3)
  end

  def new
    @calling = current_user.callings.build(:venue_id => params[:venue_id],:action_id => params[:action_id])
    respond_with @calling
  end

  def edit
    @calling = Calling.find(params[:id])
  end

  def create
    @calling = current_user.callings.build(params[:calling])
    if @calling.save
      @oauth_message = "(这是oauth同步测试) 我#{@calling.description}  #{calling_url(@calling)}"
      current_user.send_to_miniblogs( @oauth_message,
                                      :to_douban => (@calling.sync_to_douban && current_user.douban?),
                                      :to_sina => (@calling.sync_to_douban && current_user.sina?)
                                      )
    end  
    respond_with @calling
  end

  def update
    @calling.update_attributes(params[:calling])
    respond_with @calling
  end

  def destroy
    @calling.destroy
    respond_with @calling
  end
  
  def next_step
  end
  
  private
  def find_calling
    @calling = Calling.find(params[:id])
  end
  
  def clean_unread
    @calling.update_attribute(:has_new_comment,false) if @calling.user == current_user && @calling.has_new_comment
  end
  
end
