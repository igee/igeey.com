class MessagesController < ApplicationController
  before_filter :login_required
  respond_to :html, :js, :xml
  
  def index
    @unreadbox = current_user.unreadbox
    @inbox = current_user.inbox
    @outbox = current_user.outbox
  end
  
  def new
    @msg_id = params[:msg_id]
    Message.find(@msg_id).read unless @msg_id.nil?
    @user = User.find(params[:user_id])
    @message = Message.new(:from_user_id => current_user.id, :to_user_id => @user.id)
    render :layout => false if params[:layout] == 'false'
  end
  
  def create
    @message = Message.new(params[:message])
    @message.save ? flash[:msg] = "<img src='/images/icon/success.png' class='icon'> 发送成功！" : flash[:msg] = "<img src='/images/icon/failed.png' class='icon'> 发送失败！"
    redirect_to :back
  end

  def clear
    @message = Message.find(params[:id])
    @message.read
    render :text=>'true'
  end
end
