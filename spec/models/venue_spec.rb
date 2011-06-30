require 'spec_helper'

describe Message do
  
  before do
    @user = makestory
  end
  
  describe 'validation' do
    it 'should be created by name' do
      @venue = Venue.new(:latitude=>25.568692,:longitude=>109.609512,:creator_id=>@user.id)
      @venue.should_not be_valid
      
      @venue = Venue.new(:name=>'地点',:latitude=>25.568692,:longitude=>109.609512,:creator_id=>@user.id,:category=>'nature')
      @venue.should be_valid
    end
    
    it 'should be created by latitude and longitude' do
      @venue = Venue.new(:name=>'地点',:creator_id=>@user.id,:category=>'nature')
      @venue.should_not be_valid
      
      @venue = Venue.new(:name=>'地点',:latitude=>25.568692,:longitude=>109.609512,:creator_id=>@user.id,:category=>'nature')
      @venue.should be_valid
    end
    
    it 'should be created by creator_id' do
      @venue = Venue.new(:name=>'地点',:latitude=>25.568692,:longitude=>109.609512,:category=>'nature')
      @venue.should_not be_valid
      
      @venue = Venue.new(:name=>'地点',:latitude=>25.568692,:longitude=>109.609512,:creator_id=>@user.id,:category=>'nature')
      @venue.should be_valid
    end
    
    it 'should be created by categroy' do
      @venue = Venue.new(:name=>'地点',:latitude=>25.568692,:longitude=>109.609512,:creator_id=>@user.id)
      @venue.should_not be_valid
      
      @venue = Venue.new(:name=>'地点',:latitude=>25.568692,:longitude=>109.609512,:creator_id=>@user.id,:category=>'nature')
      @venue.should be_valid
    end
    
    it'should be created by category that in CATEGORIES_HASH' do
      @venue = Venue.new(:name=>'地点',:latitude=>25.568692,:longitude=>109.609512,:creator_id=>@user.id,:category=>'nature1')
      @venue.should_not be_valid
      
      @venue = Venue.new(:name=>'地点',:latitude=>25.568692,:longitude=>109.609512,:creator_id=>@user.id,:category=>'nature')
      @venue.should be_valid
    end
  end
end