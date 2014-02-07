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

  def test_should_return_all_bookings
    today = Date.today
    load_bookings(@resource, today)

    get bookings_resource_path(@resource.id), {date: today.to_s, limit: 10, status: :all}
    assert_equal 200, last_response.status
    data = JSON.parse last_response.body
    bookings = data['book']
    assert_equal 3, bookings.size

    link = data['links'].first
    assert_equal 'self', link['rel']
    assert_match bookings_resource_path(@resource.id), link['uri']
  end

  def test_should_return_two_bookings
    today = Date.today
    load_bookings(@resource, today)

    get bookings_resource_path(@resource.id), {date: today.to_s, limit: 3, status: :all}
    assert_equal 200, last_response.status
    data = JSON.parse last_response.body
    bookings = data['book']
    assert_equal 2, bookings.size
  end

  def test_should_return_zero_bookings
    today = Date.today
    load_bookings(@resource, today)

    get bookings_resource_path(@resource.id), {date: today.to_s, status: 'approved'}
    assert_equal 200, last_response.status
    data = JSON.parse last_response.body
    bookings = data['book']
    assert_equal 0, bookings.size
  end

  private

  def load_bookings(resource, today)
    bookings = [{ start_time: (today + 1.day) }, { start_time: (today + 3.days) }, { start_time: (today + 5.days) }]
    resource.bookings.create(bookings) do |r|
      r.end_time = r.start_time + 1.day
      r.status = 'pending'
    end
  end

end