require 'test_helper'

class PathsTest < MiniTest::Unit::TestCase 

  def app
    Sinatra::Application
  end

  def test_paths
    assert_equal '/', root_path
    assert_equal '/resources', resources_path
    assert_equal '/resources/1', resource_path(1)
    assert_equal '/resources/1/availability', availability_resource_path(1)
    assert_equal '/resources/1/bookings'    , bookings_resource_path(1)
    assert_equal '/resources/1/bookings/1'  , booking_resource_path(1, 1)
  end

end