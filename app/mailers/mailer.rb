class Mailer < ActionMailer::Base
  default :from => APP_CONFIG['mail_user_name']
  def reset_password(user,password)
    @password = password
    mail(:to => user.email, :subject => "爱聚网站的密码重置")  
  end  
end
