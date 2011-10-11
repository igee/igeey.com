module ApplicationHelper

  def short_text(text,length=20)
    text.mb_chars.slice(0..length).to_s.lstrip + (text.mb_chars[length].nil?? "" : "...") if text
  end
  
  def error_explanation_for(object)
    html = '<ul id="error_explanation">'
    object.errors.each do |msg|
      html << "<li>#{msg[1]}</li>"
    end
    html << '</ul>'
  end
  
  def personal_name(user)
    (current_user == user) ? "我" : user.login
  end
  
  def format_date(date)
    "#{date.year == Date.today.year ? '' : "#{date.year}年"}#{date.month}月#{date.day}日"
  end
  
  def full_date(date)
    date.strftime("%m月%d日 %X")
  end
  
  def date_interval(date)
    second = Time.now.to_i - date.to_i
    hours = second/(60*60)
    hours>23 ? "#{hours/24}天前" : (hours>1 ? "#{hours}小时前" : ((second/60)>1 ? "#{second/60}分钟前" : "#{second}秒前"))
  end
  
  def short_url(object)
    "http://#{request.host_with_port}/#{object.class.name.first.downcase}/#{object.id}"
  end
  
  def tag_list_for(tag_list)
    html = '<div class="tags">'
    html += tag_list.map{|tag| " #{link_to(tag,tag_path(tag),:class=>'tag')}\n"}.to_s
    html += '</div>'
  end
  
  def tag_links_for(tag_list,limit=2)
    html = tag_list[0..limit].map{|tag| "#{link_to(tag,tag_path(tag))}\n"}.to_s
    html += '...' if tag_list[limit+1]
    html += '无' if tag_list.blank?
    html
  end
  
  def tag_color(count)
    if count < 3
      '#9bf'
    elsif count < 6
      '#ad3'
    elsif  count < 10
      '#c9c'
    elsif count < 15
      '#fa2'
    else
      '#f70'
    end
  end

end
