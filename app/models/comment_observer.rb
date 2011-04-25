class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    @commentable = comment.commentable
    @commentable.update_attributes(:last_replied_user_id => comment.user.id,:last_replied_at => Time.now)
    users_id = (@commentable.comments.map(&:user_id)+[@commentable.user_id]-[comment.user_id]).uniq
    Notification.update(users_id, @commentable)
  end
end
