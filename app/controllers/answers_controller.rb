class AnswersController < ApplicationController
  before_filter :login_required, :except => [:index, :show,:redirect]
  respond_to :html, :js, :xml
  before_filter :find_answer,:only => [:edit,:update,:destroy,:show,:redirect,:veto]
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
  
  def show
  end

  def edit
  end
  
  def destroy
    @answer.destroy
    redirect_to question_path(@question)
  end
  
  def update
    @answer.update_attributes(params[:answer])
    redirect_to question_path(@question)
  end
  
  def veto
    user_ids = (@answer.vetos_user_ids + " #{current_user.id}").split(' ').uniq
    @answer.update_attribute(:vetos_count,user_ids.length)
    @answer.update_attribute(:vetos_user_ids,user_ids.join(' '))
    respond_to do |format|
      format.html {redirect_to params[:back_path] || :back}
      format.js {render :text => ''} 
    end
  end
  
  def redirect
    redirect_to "#{question_path(@answer.question)}##{@answer.id}"
  end
  private
  
  def find_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end
  
  def check_permission
    redirect_to :back unless @answer.owned_by?(current_user) 
  end
end
