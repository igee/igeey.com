module ApplicationHelper
  
  def short_text(text,length=20)
    text.mb_chars.slice(0..length).to_s.lstrip + (text.mb_chars[length].nil?? "" : "...")
  end
  
  def error_explanation_for(object)
    html = '<ul id="error_explanation">'
    object.errors.each do |msg|
      html << "<li>#{msg[1]}</li>"
    end
    html << '</ul>'
  end
  
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
    html = "同步到： "
    html << "#{image_tag('/images/icon/sina.gif',:class=> 'icon')} 新浪微博#{form.check_box :sync_to_sina ,:disabled => (current_user.sina? ? false : true),:checked => current_user.sina?}"
    html << "#{image_tag('/images/icon/douban.gif',:class => 'icon')} 豆瓣#{form.check_box :sync_to_douban ,:disabled => (current_user.douban? ? false : true),:checked => current_user.douban?}"
    html << "　#{link_to '无法勾选同步？快去设置吧',"#{setting_path}?back_path=#{request.path}"}" unless current_user.sina? && current_user.douban?
    html
  end
end
