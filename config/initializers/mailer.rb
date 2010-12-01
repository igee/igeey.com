ActionMailer::Base.smtp_settings = {  
  :address              => "smtp.gmail.com",  
  :port                 => 587,  
  :user_name            => APP_CONFIG['mail_user_name'],  
  :password             => APP_CONFIG['mail_password'],  
  :authentication       => "plain",  
  :enable_starttls_auto => true  
}  