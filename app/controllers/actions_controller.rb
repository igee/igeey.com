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
    @question = Question.new
    @timeline = @action.taggings.where(['taggable_type != ?','Question']).map(&:taggable)
  end
  
  def edit
  end

  def update
    @action.update_attributes(params[:_action])
    respond_with @action
  end

  def create
    @action = Action.new(params[:_action])
    @action.user = current_user
    @action.save
    respond_with @action
  end
  
  def questions
    @question = Question.new
    @items = @action.questions.paginate(:page => params[:page], :per_page => 10)
    render 'see_all'
  end
  
  private
  
  def find_action
    @action = Action.find(params[:id])
  end
  
  def check_permission
    
  end
end
