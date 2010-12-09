class TopicObserver < ActiveRecord::Observer
  def after_create(topic)
    topic.venue.follows.map{|a| a.update_attributes(:has_new_topic => true)} if topic.venue_id.present?
  end
end
