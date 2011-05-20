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
  
  def short_url(object)
    "http://#{request.host_with_port}/#{object.class.name.first.downcase}/#{object.id}"
  end
  
  def tag_list_for(tag_list)
    html = '<ul class="tag_cloud">'
    html += tag_list.map{|tag| "  <li>#{link_to(tag,tag_path(tag))}</li>\n"}.to_s
    html += '</ul>'
  end
  
  def tag_links_for(tag_list,limit=2)
    html = tag_list[0..limit].map{|tag| "#{link_to(tag,tag_path(tag))}\n"}.to_s
    html += '...' if tag_list[limit+1]
    html += '无' if tag_list.blank?
    html
  end
  
end
