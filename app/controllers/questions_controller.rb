class QuestionsController < ApplicationController
  def show
    @question = Question.find(params[:id])
    @answer = Answer.new
  end
  
  def create
    @question = current_user.questions.build(params[:question])
    @question.save
    redirect_to :back
  end
end
