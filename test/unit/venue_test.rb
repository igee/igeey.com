require 'test_helper'

class VenueTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :venues
  
  test "should_require_name" do
    g = create_venue(:name => nil)
    assert_equal g.errors[:name],["can't be blank"]
  end
  
  test "should_require_latitude" do
    g = create_venue(:latitude => nil)
    assert_equal g.errors[:latitude],["can't be blank"]
  end
  
  test "should_require_longitude" do
    g = create_venue(:longitude => nil)
    assert_equal g.errors[:longitude],["can't be blank"]
  end
  
  test "should_limit_intro_length" do
    g = create_venue(:intro => "c"*141)
    assert_equal g.errors[:intro],["is too long (maximum is 140 characters)"]
  end
  
  test "category_should_in_defalut_categories_slot" do
    g = create_venue(:category => '*')
    assert_equal g.errors[:category],["is not included in the list"]
  end
  
  protected
  def create_venue(options = {})
    record = Venue.new({:name => 'TestCity',:latitude => 0.0 ,:longitude => 0.0}.merge(options))
    record.save
    record
  end

end
