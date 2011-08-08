class Mailer < ActionMailer::Base
  default :from => APP_CONFIG['mail_user_name']
  def reset_password(user,password)
    @password = password
    mail(:to => user.email, :subject => "爱聚网站的密码重置")  
  end
  
  def send_new_feedback(feedback)
    if APP_CONFIG['developer_mail'].present?
      @feedback = feedback
      mail(:to => APP_CONFIG['developer_mail'], :subject => "爱聚网站用户反馈")
    end
  end  
  
  def send_new_problem(problem)
    if APP_CONFIG['developer_mail'].present?
      @problem = problem 
      mail(:to => APP_CONFIG['developer_mail'], :subject => "新问题提交:#{@problem.name}")
    end
  end 
end
