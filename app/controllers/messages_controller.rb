class MessagesController < ApplicationController
  before_filter :login_required
  respond_to :html, :js, :xml
  
  def index
    @inbox = current_user.inbox
    @outbox = current_user.outbox
  end
  
  def new
    @user = User.find(params[:user_id])
    @message = Message.new(:from_user_id => current_user.id, :to_user_id => @user.id)
    render :layout => false if params[:layout] == 'false'
  end
  
  def create
    @message = Message.new(params[:message])
    @message.save
    redirect_to :back
  end
end
