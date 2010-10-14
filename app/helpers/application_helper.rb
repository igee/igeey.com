module ApplicationHelper
  def who_at_where(user,venue)
    "#{link_to user.login,user}@#{link_to venue.name,venue}"
  end
  
  def personal_name(user)
    (current_user == user) ? "我" : user.login
  end
end
