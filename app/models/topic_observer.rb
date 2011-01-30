class TopicObserver < ActiveRecord::Observer
  def after_create(topic)
    topic.forumable.follows.map{|a| a.update_attributes(:has_new_topic => true)} if topic.forumable.present?
  end
end
