require 'test_helper'

class BookingsTest < MiniTest::Unit::TestCase 
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    @resource ||= Resource.first_or_create!(name: 'A resource', description: 'A description')
  end

  def teardown
    Resource.delete_all
    Booking.delete_all
  end

  def test_non_existing_resource_should_return_404
    get bookings_resource_path(999)
    assert_equal 404, last_response.status
  end

#  def test_should_return_all_bookings
#    today = Date.today
#
#    @resource.bookings.create!(start_time: (today + 1.day) , end_time: (today + 2.days), status: 'pending')
#    @resource.bookings.create!(start_time: (today + 3.days), end_time: (today + 4.days), status: 'pending' )
#    @resource.bookings.create!(start_time: (today + 5.days), end_time: (today + 6.days), status: 'pending' )
#
#    get bookings_resource_path(@resource.id), {date: today.to_s, limit: 10, status: :all}
#    assert_equal 200, last_response.status
#    data = JSON.parse last_response.body
#    bookings = data['bookings']
#    assert_equal 3, bookings.size
#  end

end