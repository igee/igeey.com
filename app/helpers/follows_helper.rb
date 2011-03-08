module FollowsHelper
  def follow_to(followable)
    if logged_in? && current_user.following?(followable)
      '已关注 ' + link_to((raw " <span>取消?</span>"),follow_path(followable.follows.find_by_user_id(current_user.id)),:method => :delete)
    else  
      link_to("+关注","#{follows_path}?followable_type=#{followable.class}&followable_id=#{followable.id}",:method => :post,:class => 'button')
    end
  end
  
  def follow_status(followable)
    if logged_in? && current_user.following?(followable)
      "<span>关注中</span> | #{link_to raw("取消"),follow_path(followable.follows.find_by_user_id(current_user.id)),:method => :delete,:confirm => '确定要取消关注么？'}"
    else  
      link_to("+关注","#{follows_path}?followable_type=#{followable.class}&followable_id=#{followable.id}",:method => :post)
    end
  end
end
