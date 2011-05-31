require 'spec_helper'

describe Vote do
  before do
    @user_1 = makestory
    @user_2 = mhb
    @user_3 = andrew

    @question = Question.new(:user_id=>@user_1.id, :title=>'question?', :tag_list=>'tag_1')
    @question.save
    @answer = Answer.new(:user_id=>@user_1.id, :question_id=>@question.id, :content=>'answer')
    @answer.save
  end
  
  describe 'validation' do
    it 'user should only be one vote to a voteable' do
      vote = Vote.new(:user_id=>@user_2.id, :voteable_type=>@answer.class.to_s, :voteable_id=>@answer.id)
      vote.should be_valid
      vote.save
      
      vote = Vote.new(:user_id=>@user_2.id, :voteable_type=>@answer.class.to_s, :voteable_id=>@answer.id)
      vote.should_not be_valid
    end
    
    it 'user should not vote on any voteable to their own' do
      vote = Vote.new(:user_id=>@user_1.id, :voteable_type=>@answer.class.to_s, :voteable_id=>@answer.id)
      vote.should_not be_valid
    end
  end
  
  it 'after the vote, the voteable should be plus 1 votes' do
    Answer.where(:id=>@answer.id).first.votes_count.should == 0
    
    vote = Vote.new(:user_id=>@user_2.id, :voteable_type=>@answer.class.to_s, :voteable_id=>@answer.id)
    vote.save
    Answer.where(:id=>@answer.id).first.votes_count.should == 1
    
    vote = Vote.new(:user_id=>@user_3.id, :voteable_type=>@answer.class.to_s, :voteable_id=>@answer.id)
    vote.save
    Answer.where(:id=>@answer.id).first.votes_count.should == 2
  end
end