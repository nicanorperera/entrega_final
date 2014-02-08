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

  def test_should_show_booking
    @booking = @resource.bookings.create(start_time: Date.today, end_time: (Date.today+1), status: 'pending')
    show_path = booking_resource_path(@booking.id, @resource.id)

    get show_path
    assert_status 200
    #TODO: test if json is well formed
  end

  def test_non_existing_resource_should_return_404
    get bookings_resource_path(999)
    assert_status 404
  end

  def test_should_return_all_bookings
    today = Date.today
    bks = load_bookings(@resource, today)

    get bookings_resource_path(@resource.id), {date: today.to_s, limit: 10, status: :all}
    assert_status 200
    data = JSON.parse last_response.body
    bookings = data['book']
    assert_equal 3, bookings.size

    booking = bookings.first
    links = booking['links']
    assert_equal 'self', links[0]['rel']
    assert_equal 'resource', links[1]['rel']
    assert_equal 'accept', links[2]['rel']
    assert_equal 'reject', links[3]['rel']

    link = data['links'].first
    assert_equal 'self', link['rel']
    assert_match bookings_resource_path(@resource.id), link['uri']
  end

  def test_should_return_two_bookings
    today = Date.today
    load_bookings(@resource, today)

    get bookings_resource_path(@resource.id), {date: today.to_s, limit: 3, status: :all}
    assert_status 200
    data = JSON.parse last_response.body
    bookings = data['book']
    assert_equal 2, bookings.size
  end

  def test_should_return_zero_bookings
    today = Date.today
    load_bookings(@resource, today)

    get bookings_resource_path(@resource.id), {date: today.to_s, status: 'approved'}
    assert_status 200
    data = JSON.parse last_response.body
    bookings = data['book']
    assert_equal 0, bookings.size
  end

  def test_making_and_cancelling_bookings
    post bookings_resource_path(@resource.id), {from: Date.today.to_s, to: (Date.today + 1).to_s}
    assert_status 201

    @booking = @resource.bookings.first

    delete booking_resource_path(@booking.id, @resource.id)
    assert_status 200

    delete booking_resource_path(@booking.id, @resource.id)
    assert_status 404
  end

  def test_authorizing_bookings
    load_bookings(@resource, Date.today)
    booking = @resource.bookings.first

    put booking_resource_path(booking.id, @resource.id)
    assert_status 200

    post bookings_resource_path(@resource.id), {from: Date.today.to_s, to: (Date.today + 1).to_s}
    assert_status 409

    put booking_resource_path(booking.id, @resource.id)
    assert_status 409
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