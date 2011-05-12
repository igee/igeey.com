class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    @commentable = comment.commentable
    @commentable.update_attributes(:last_replied_user_id => comment.user.id,:last_replied_at => Time.now)
    Notification.update(@commentable,comment)
  end
end
