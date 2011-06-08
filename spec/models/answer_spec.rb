require 'spec_helper'

describe Answer do
  before do
    @user = Factory(:user)
    @user_1 = Factory(:green)
    
    @question = Question.new(:user_id=>@user.id, :title=>'question?', :tag_list=>['tag'])
    @question.save
    
    @answer_1 = Answer.new(:user_id=>@user_1.id, :question_id=>@question.id, :content=>'answer1234')
    @answer_1.save
  end
  
  describe 'validation' do
    it 'should be created by question' do
      @answer = Answer.new(:user_id=>@user.id, :content=>'answer1234')
      @answer.should_not be_valid
      
      @answer = Answer.new(:user_id=>@user.id, :question_id=>@question.id, :content=>'answer1234')
      @answer.should be_valid
    end
    
    it 'should be created by user' do
      @answer = Answer.new(:question_id=>@question.id, :content=>'answer1234')
      @answer.should_not be_valid
      
      @answer = Answer.new(:user_id=>@user.id, :question_id=>@question.id, :content=>'answer1234')
      @answer.should be_valid
    end
    
    it 'should be created by content' do
      @answer = Answer.new(:user_id=>@user.id, :question_id=>@question.id)
      @answer.should_not be_valid
      
      @answer = Answer.new(:user_id=>@user.id, :question_id=>@question.id, :content=>'answer1234')
      @answer.should be_valid
    end
    
    it 'content should not be less than 10 words' do
      @answer = Answer.new(:user_id=>@user.id, :question_id=>@question.id, :content=>'answer123')
      @answer.should_not be_valid
      
      @answer = Answer.new(:user_id=>@user.id, :question_id=>@question.id, :content=>'answer1234')
      @answer.should be_valid
    end
    
    it 'should only be one answer to the same user with a question' do
      @answer = Answer.new(:user_id=>@answer_1.user.id, :question_id=>@question.id, :content=>'answer1234')
      @answer.should_not be_valid
    end
    
    it 'should be answered multiple users with a question' do
      @answer = Answer.new(:user_id=>@user.id, :question_id=>@question.id, :content=>'answer1234')
      @answer.should be_valid
    end
  end
  
  it 'should be commented' do
    @comment = Comment.new(:user_id=>@user.id, :content=>'comment', :commentable_type=>@answer_1.class.to_s, :commentable_id=>@answer_1.id)
    @comment.should be_valid
  end
  
  it 'should be voted' do
    @vote = Vote.new(:user_id=>@user.id, :voteable_type=>@answer_1.class.to_s, :voteable_id=>@answer_1.id)
    @vote.should be_valid
  end
end