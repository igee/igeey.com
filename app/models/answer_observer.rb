class AnswerObserver < ActiveRecord::Observer
  def after_create(answer)
    @question = Question.find(answer.question_id)
    @question.update_attribute(:last_answered_at,Time.now)
  end
end