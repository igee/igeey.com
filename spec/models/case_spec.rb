require 'spec_helper'

describe Case do
  before do
    @user = Factory(:user)
  end
  
  describe 'validation' do
    context 'when user create a case' do
      it 'should be created under a problem' do
        @case = Case.new(:user_id=>@user.id,:intro=>'case_intro',:photo_file_name=>'',:address=>'')
        @case.should be_valid
      end
    end
    
    it 'could be commented' do
      @case = Factory(:case)
      @comment = Comment.new(:user_id=>@user.id, :content=>'comment', :commentable_type=>@case.class.to_s, :commentable_id=>@case.id)
      @comment.should be_valid
    end
  end
end
