require 'spec_helper'

describe Task do
  
  describe '#validate' do
    it 'should can not save without user_id' do
       @task = Factory.build(:task)
       @task.user_id = nil
       @task.should_not be_valid
    end

    it 'should can not save without venue_id' do
       @task = Factory.build(:task)
       @task.venue_id = nil
       @task.should_not be_valid
    end

    it 'should can not save without title or title is empty' do
       @task = Factory.build(:task)
       @task.title = nil
       @task.should_not be_valid
       @task.title = nil
       @task.should_not be_valid
    end
  end
end
