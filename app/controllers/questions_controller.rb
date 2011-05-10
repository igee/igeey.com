class QuestionsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_question, :except => [:index, :new, :create,:more]
  respond_to :html,:json
  
  def show
    @answer = Answer.new
  end
  
  def edit
  end

  def update
    @question.update_attributes(params[:question])
    respond_with @question
  end

  def create
    @question = current_user.questions.build(params[:question])
    @question.save
    redirect_to :back
  end
  
  def more
    @items = Question.paginate(:page => params[:page], :per_page => 10)
    render '/public/more_items',:layout => false
  end
  
  private
  
  def find_question
    @question = Question.find(params[:id])
  end
  
  def check_permission
    redirct_to :back unless @answer.owned_by?(current_user) 
  end
end
