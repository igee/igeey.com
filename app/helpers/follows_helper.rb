module FollowsHelper
  def follow_to(followable)
    if logged_in? && current_user.is_following?(followable)
      button_to("正在关注",follow_path(followable.follows.find_by_user_id(current_user.id)),:method => :delete)
    else  
      button_to("+ 关注","#{follows_path}?followable_type=#{followable.class}&followable_id=#{followable.id}",:method => :post)
    end
  end
  
  def care_about(followable)
    if logged_in? && current_user.is_following?(followable)
      raw "<span>你关心这个问题 | #{link_to('取消',follow_path(followable.follows.find_by_user_id(current_user.id)),:method => :delete,:class => 'selected')}</span>"
    else
      button_to("+ 关心","#{follows_path}?followable_type=#{followable.class}&followable_id=#{followable.id}",:method => :post)
    end
  end
  
  def follow_status(followable)
    if logged_in? && current_user.is_following?(followable)
      "<span>关注中</span> | #{link_to raw("取消"),follow_path(followable.follows.find_by_user_id(current_user.id)),:method => :delete,:confirm => '确定要取消关注么？'}"
    else  
      link_to("+ 关注","#{follows_path}?followable_type=#{followable.class}&followable_id=#{followable.id}",:method => :post)
    end
  end
end
