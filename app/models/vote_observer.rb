class VoteObserver < ActiveRecord::Observer
  def after_create(vote)
    update_count(vote)
  end

  def after_destroy(vote)
    update_count(vote)
  end

  def update_count(vote)
    voteable = vote.voteable
    voteable.positive_count = vote.voteable.votes.where(:positive => true).size
    voteable.negative_count = vote.voteable.votes.where(:positive => false).size
    voteable.offset_count = voteable.positive_count - voteable.negative_count 
    voteable.save
  end

end
