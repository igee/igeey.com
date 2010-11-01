module ApplicationHelper
  
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
    html << "#{image_tag('/images/icon/sina.gif',:class=> 'icon')} 新浪微博#{form.check_box :sync_to_sina ,:disabled => (current_user.sina? ? false : true)}　"
    html << "#{image_tag('/images/icon/douban.gif',:class => 'icon')} 豆瓣#{form.check_box :sync_to_douban ,:disabled => (current_user.douban? ? false : true)}"
    html << "<br/>#{link_to '无法同步？快去设置吧',setting_path,:target => '_blank',:class => 'with_explain',:title => '点击页面右上角的用户设置，连接你的社区帐号，把你公益行动分享给你的朋友。'}" unless current_user.sina? || current_user.douban?
    html
  end
end
