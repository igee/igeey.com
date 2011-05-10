class QuestionObserver < ActiveRecord::Observer
  def before_create(question)
    question.last_answered_at = Time.now
  end
end