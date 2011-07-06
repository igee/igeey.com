require 'spec_helper'

describe Message do
  
  before do
    @user1 = Factory(:user)
    @user2 = Factory(:green)
  end
  
  describe 'validation' do
    it 'should be created by from_user_id' do
      @message = Message.new(:to_user_id=>@user2.id, :content=>'hello')
      @message.should_not be_valid
      
      @message = Message.new(:from_user_id=>@user1.id, :to_user_id=>@user2.id, :content=>'hello')
      @message.should be_valid
    end
    
    it 'should be created by to_user_id' do
      @message = Message.new(:from_user_id=>@user1.id, :content=>'hello')
      @message.should_not be_valid
      
      @message = Message.new(:from_user_id=>@user1.id, :to_user_id=>@user2.id, :content=>'hello')
      @message.should be_valid
    end
    
    it 'should be created by content' do
      @message = Message.new(:from_user_id=>@user1.id, :to_user_id=>@user2.id)
      @message.should_not be_valid
      
      @message = Message.new(:from_user_id=>@user1.id, :to_user_id=>@user2.id, :content=>'hello')
      @message.should be_valid
    end
  end
end
