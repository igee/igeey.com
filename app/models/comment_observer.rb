class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    comment.commentable.update_attributes(:has_new_comment => true)
  end
end
