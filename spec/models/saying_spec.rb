require 'spec_helper'

describe Saying do
  before do
    @user1 = makestory
  end
  describe 'validation' do
    it 'should be created by user_id' do
      @saying = Saying.new(:venue_id=>1, :content=>'saying')
      @saying.should_not be_valid
      
      @saying = Saying.new(:user_id=>@user1.id, :venue_id=>1, :content=>'saying')
      @saying.should be_valid
    end
    
    it 'should be created by venue_id' do
      @saying = Saying.new(:user_id=>@user1.id, :content=>'saying')
      @saying.should_not be_valid
      
      @saying = Saying.new(:user_id=>@user1.id, :venue_id=>1, :content=>'saying')
      @saying.should be_valid
    end
    
    it 'should be created by content' do
      @saying = Saying.new(:user_id=>@user1.id, :venue_id=>1)
      @saying.should_not be_valid
      
      @saying = Saying.new(:user_id=>@user1.id, :venue_id=>1, :content=>'saying')
      @saying.should be_valid
    end
    
    it 'should be created from 1 to 140 words of content' do
      content = ''
      @saying = Saying.new(:user_id=>@user1.id, :venue_id=>1, :content=>content)
      @saying.should_not be_valid
      
      content = '@'
      @saying = Saying.new(:user_id=>@user1.id, :venue_id=>1, :content=>content)
      @saying.should be_valid
      
      content = '@'*140
      @saying = Saying.new(:user_id=>@user1.id, :venue_id=>1, :content=>content)
      @saying.should be_valid
      
      content = '@'*141
      @saying = Saying.new(:user_id=>@user1.id, :venue_id=>1, :content=>content)
      @saying.should_not be_valid
    end
  end
  
  it 'should be commented' do
    @saying = Saying.new(:user_id=>@user1.id, :venue_id=>1, :content=>'saying')
    @saying.save
    
    @comment = Comment.new(:user_id=>@user1.id, :content=>'comment', :commentable_type=>@saying.class.to_s, :commentable_id=>@saying.id)
    @comment.should be_valid
  end
end