require 'test_helper'

class GeoTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :geos
  
  test "should_require_name" do
    g = create_geo(:name => nil)
    assert_equal g.errors[:name],["can't be blank"]
  end
  
  test "should_require_latitude" do
    g = create_geo(:latitude => nil)
    assert_equal g.errors[:latitude],["can't be blank"]
  end
  
  test "should_require_longitude" do
    g = create_geo(:longitude => nil)
    assert_equal g.errors[:longitude],["can't be blank"]
  end
  
  protected
  def create_geo(options = {})
    record = Geo.new({:name => 'TestCity',:latitude => 0.0 ,:longitude => 0.0,:zoom_level => 9}.merge(options))
    record.save
    record
  end
  
end
