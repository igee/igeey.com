class QuestionsController < ApplicationController
  before_filter :login_required, :except => [:index, :show,:more]
  before_filter :find_question, :except => [:index, :new, :create,:more]
  respond_to :html,:json
  
  def show
    @answer = Answer.new
    @answers = @question.answers.where('vetos_count < 3').order('votes_count desc')
    @vetoed_answers = @question.answers.where('vetos_count >= 3').order('votes_count desc')
    @questions = @question.related_questions[0..9]
  end
  
  def edit
  end

  def update
    @question.update_attributes(params[:question])
    respond_with @question
  end

  def create
    @question = current_user.questions.build(params[:question])
    if @question.save
      flash[:dialog] = "<a href='#{new_sync_path}?syncable_type=#{@question.class}&syncable_id=#{@question.id}' class='open_dialog' title='传播这个问题'>同步</a>" 
    end
    redirect_to :back
  end
  
  def destroy
    redirect_path = tag_path(@question.tag_list[0])
    @question.destroy
    redirect_to redirect_path
  end
  
  def more
    @items = Question.unscoped.order('last_answered_at desc').paginate(:page => params[:page], :per_page => 10)
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
