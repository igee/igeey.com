class AnswerObserver < ActiveRecord::Observer
  def after_create(answer)
    @question = Question.find(answer.question_id)
    @question.update_attribute(:last_answered_at,Time.now)
    users_id =(@question.answers.map(&:user_id)+[@question.user_id]-[answer.user_id]).uniq
    Notification.update(users_id, @question)
  end
end