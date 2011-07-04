require 'spec_helper'

describe Problem do
  before do
    @user = Factory(:user)
  end
  
  describe 'validation' do
    it 'should be created by name' do
      @problem = Problem.new(:creator_id=>@user.id)
      @problem.should_not be_valid
      
      @problem = Problem.new(:name=>'社区小广告',:creator_id=>@user.id)
      @problem.should be_valid
    end
    
    it 'should be created by creator_id' do
      @problem = Problem.new(:name=>'社区小广告')
      @problem.should_not be_valid
      
      @problem = Problem.new(:name=>'社区小广告',:creator_id=>@user.id)
      @problem.should be_valid
    end
  end
  
  it 'could be had intro' do
    @problem = Problem.new(:name=>'社区小广告',:creator_id=>@user.id,:intro=>'大大小小的社区中到处都是乱贴乱画的小广告')
    @problem.should be_valid
  end
  
  it 'could be commented' do
    @problem = Factory(:problem)
    @comment = Comment.new(:user_id=>@user.id, :content=>'comment', :commentable_type=>@problem.class.to_s, :commentable_id=>@problem.id)
    @comment.should be_valid
  end
end
