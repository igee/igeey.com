class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    @commentable = comment.commentable
    users_id = (@commentable.comments.map(&:user_id)+[@commentable.user_id]-[comment.user_id]).uniq
    Notification.update(users_id, @commentable)
  end
end
