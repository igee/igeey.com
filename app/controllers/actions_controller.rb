class ActionsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_action, :except => [:index, :new, :create]
  respond_to :html,:json
  
  def index
  end
  
  def new
    @action = Action.new
  end
  
  def show
  end
  
  def edit
  end

  def update
    @action.update_attributes(params[:action])
    respond_with @action
  end

  def create
    @action = Action.build(params[:action])
    @action.user = current_user
    @action.save
    respond_with @action
  end
  
  private
  
  def find_action
    @action = Action.find(params[:id])
  end
  
  def check_permission
    
  end
end
