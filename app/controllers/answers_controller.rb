class AnswersController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  respond_to :html, :js, :xml
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
end
