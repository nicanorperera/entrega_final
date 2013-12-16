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
    Booking.delete_all
  end

  def test_show_bookings
    today = Date.today
    @resource.bookings.create!(start: (today + 1.day) , end: (today + 2.days) )
    @resource.bookings.create!(start: (today + 3.days), end: (today + 4.days) )
    @resource.bookings.create!(start: (today + 5.days), end: (today + 6.days) )

    get "/resources/#{@resource.id}/bookings", {date: today.to_s, limit: 30, status: :all}
    assert_equal 200, last_response.status
    data = JSON.parse last_response.body
    bookings = data['bookings']
    #assert_equal 3, bookings.size
  end

end