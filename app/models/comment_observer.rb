class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    @commentable = comment.commentable
    (@commentable.comments - [comment]).map{|a| a.update_attributes(:has_new_comment => true)}
    @commentable.update_attribute(:has_new_comment ,true) unless @commentable.user_id == comment.user_id
    @commentable.update_attributes(:last_replied_user_id => comment.user.id,:last_replied_at => Time.now)
  end
  
  def before_validation(comment)
    comment.content = comment.content.strip
  end
end
