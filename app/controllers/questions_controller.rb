class QuestionsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
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
