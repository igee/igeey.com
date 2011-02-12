class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    @commentable = comment.commentable
    unless comment.commentable_type == 'Checkin'
      @commentable.follows.map{|a| a.update_attributes(:has_new_comment => true)}
      @commentable.comments.map{|a| a.update_attributes(:has_new_comment => true)}
      @commentable.update_attribute(:has_new_comment ,true) 
    end
    @commentable.update_attributes(:last_replied_user_id => comment.user.id,:last_replied_at => Time.now) if ['Topic','Checkin'].include?(comment.commentable_type)
  end
  
  def before_validation(comment)
    comment.content = comment.content.strip
  end
end
