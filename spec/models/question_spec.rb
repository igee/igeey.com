require 'spec_helper'

describe Question do
  before do
    @user = makestory
  end
  
  describe 'validation' do
    it 'should be created by user_id' do
      @question = Question.new(:title=>'question?', :tag_list=>['tag'])
      @question.should_not be_valid
      
      @question = Question.new(:user_id=>@user.id, :title=>'question?', :tag_list=>['tag'])
      @question.should be_valid
    end
    
    it 'should be created by title' do
      @question = Question.new(:user_id=>@user.id, :tag_list=>['tag'])
      @question.should_not be_valid
      
      @question = Question.new(:user_id=>@user.id, :title=>'question?', :tag_list=>['tag'])
      @question.should be_valid
    end
    
    it 'should be created by tag_list' do
      @question = Question.new(:user_id=>@user.id, :title=>'question?')
      @question.should_not be_valid
      
      @question = Question.new(:user_id=>@user.id, :title=>'question?', :tag_list=>['tag'])
      @question.should be_valid
    end
  end
  
  it 'should have related questions if have the same tag of question' do
    @question_1 = Question.new(:user_id=>@user.id, :title=>'question1?', :tag_list=>['tag1','tag2'])
    @question_1.save
    @question_1.related_questions.should == []
    
    @question_2 = Question.new(:user_id=>@user.id, :title=>'question2?', :tag_list=>['tag3'])
    @question_2.save
    @question_1.related_questions.should == []
    
    @question_3 = Question.new(:user_id=>@user.id, :title=>'quesiton3?', :tag_list=>['tag1','tag3'])
    @question_3.save
    @question_1.related_questions.should == [@question_3]
    @question_2.related_questions.should == [@question_3]
    @question_3.related_questions.should == [@question_1, @question_2] || [@question_2, @question_1]
  end
end