class UserObserver < ActiveRecord::Observer

  def after_create(user)
    #UserMailer.signup_notification(user).deliver
    user.check_badge_condition_on('id')
  end

  def after_save(user)
    #UserMailer.activation(user).deliver if user.recently_activated?
  end
  
end
