module VotesHelper
  def vote_to(voteable)
    if logged_in? && current_user.is_voted?(voteable)
      button_to("已喜欢",vote_path(voteable.votes.find_by_user_id(current_user.id)),:method => :delete)
    else  
      button_to("+ 喜欢","#{votes_path}?voteable_type=#{voteable.class}&voteable_id=#{voteable.id}&positive=true",:method => :post)
    end
  end
end
