module ApplicationHelper
  def who_at_where(user,venue)
    "#{link_to user.login,user}@#{link_to venue.name,venue}"
  end
  
  def who_and_when(user,date)
    "#{link_to user.login,user} #{format_date(date)}"
  end
  
  def personal_name(user)
    (current_user == user) ? "我" : user.login
  end
  
  def format_date(date)
    "#{date.year == Date.today.year ? '' : "#{date.year}年"}#{date.month}月#{date.day}日"
  end
  
  def sync_form_tag(form)
    html = ""
    html << "#{form.check_box :sync_to_sina ,:disabled => (current_user.sina? ? false : true)} 同步到新浪微博 "
    html << "#{form.check_box :sync_to_douban ,:disabled => (current_user.douban? ? false : true)} 同步到豆瓣 "
  end
end
