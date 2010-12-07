class Mailer < ActionMailer::Base
  default :from => APP_CONFIG['mail_user_name']
  def reset_password(user,password)
    @password = password
    mail(:to => user.email, :subject => "爱聚网站的密码重置")  
  end
  
  def send_to_developer(content,email)
    if APP_CONFIG['developer_mail'].present?
      @email = email
      @content = content
      mail(:to => APP_CONFIG['developer_mail'], :subject => "爱聚网站用户反馈")
    end
  end  
end
