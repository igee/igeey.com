class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    @commentable = comment.commentable
    @commentable.update_attribute(:has_new_comment ,true)
  end
end
