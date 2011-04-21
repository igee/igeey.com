class AnswersController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  respond_to :html, :js, :xml
  before_filter :check_permission, :only => [:destroy,:update]
  def new
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build
  end
  
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(params[:answer])
    @answer.user  = current_user
    @answer.save
    redirect_to question_path(@question)
  end
  
  def edit
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update_attributes(params[:answer])
    redirect_to question_path(@question)
  end
  
  def update
    @answer = Answer.find(params[:id])
    @answer.update_attributes(params[:answer])
    redirect_to question_path(@question)
  end
  
  private
  
  def find_photo
    @answer = Answer.find(params[:id])
  end
  
  def check_permission
    redirct_to :back unless @answer.owned_by?(current_user) 
  end
end
