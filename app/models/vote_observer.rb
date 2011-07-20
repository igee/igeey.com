class VoteObserver < ActiveRecord::Observer
  def after_create(vote)
    unless vote.is_agree.nil?
      @voteable = vote.voteable
      agree_count = Vote.where(:voteable_type=>@voteable.class.to_s,:voteable_id=>@voteable.id,:is_agree=>true).count
      disagree_count = Vote.where(:voteable_type=>@voteable.class.to_s,:voteable_id=>@voteable.id,:is_agree=>false).count
      @voteable.update_attributes(:agree_count=>agree_count, :disagree_count=>disagree_count)
      @voteable.save
    end
  end
end
