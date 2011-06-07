require 'spec_helper'

describe Record do
  before do
    @user = makestory
    @user_1 = mhb
    
    @task = Task.new()
    @task.save
    
    @plan = Plan.new()
    @plan.save
    
    @venue = Venue.new()
    @venue.save
  end
  
  describe 'validation' do
    it 'should be created by task_id' do
      @record = Record.new(:user_id=>@user.id, :plan_id=>@plan.id, :title=>'record title', :content=>'record content', :venue_id=>@venue.id)
      @record.should_not be_valid
      
      @record = Record.new(:user_id=>@user.id, :task_id=>@task.id, :plan_id=>@plan.id, :title=>'record title', :content=>'record content', :venue_id=>@venue.id)
      @record.should be_valid
    end
    
    it 'should be created by plan_id' do
      @record = Record.new(:user_id=>@user.id, :task_id=>@task.id, :title=>'record title', :content=>'record content', :venue_id=>@venue.id)
      @record.should_not be_valid
      
      @record = Record.new(:user_id=>@user.id, :task_id=>@task.id, :plan_id=>@plan.id, :title=>'record title', :content=>'record content', :venue_id=>@venue.id)
      @record.should be_valid
    end
    
    it 'should be created by user_id' do
      @record = Record.new(:task_id=>@task.id, :plan_id=>@plan.id, :title=>'record title', :content=>'record content', :venue_id=>@venue.id)
      @record.should_not be_valid
      
      @record = Record.new(:user_id=>@user.id, :task_id=>@task.id, :plan_id=>@plan.id, :title=>'record title', :content=>'record content', :venue_id=>@venue.id)
      @record.should be_valid
    end
    
    it 'should be created by title' do
      @record = Record.new(:user_id=>@user.id, :task_id=>@task.id, :plan_id=>@plan.id, :content=>'record content', :venue_id=>@venue.id)
      @record.should_not be_valid
      
      @record = Record.new(:user_id=>@user.id, :task_id=>@task.id, :plan_id=>@plan.id, :title=>'record title', :content=>'record content', :venue_id=>@venue.id)
      @record.should be_valid
    end
    
    it 'should be created by content' do
      @record = Record.new(:user_id=>@user.id, :task_id=>@task.id, :plan_id=>@plan.id, :title=>'record title', :venue_id=>@venue.id)
      @record.should_not be_valid
      
      @record = Record.new(:user_id=>@user.id, :task_id=>@task.id, :plan_id=>@plan.id, :title=>'record title', :content=>'record content', :venue_id=>@venue.id)
      @record.should be_valid
    end
    
    it 'should be created by venue_id' do
      @record = Record.new(:user_id=>@user.id, :task_id=>@task.id, :plan_id=>@plan.id, :title=>'record title', :content=>'record content')
      @record.should_not be_valid
      
      @record = Record.new(:user_id=>@user.id, :task_id=>@task.id, :plan_id=>@plan.id, :title=>'record title', :content=>'record content', :venue_id=>@venue.id)
      @record.should be_valid
    end
    
    it 'should be created when there are plans and plans under the same task' do
    end
    
    it 'should be created where there are plans and plans user_id and the user_id should be equal' do
    end
  end
end