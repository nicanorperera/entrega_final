require 'test_helper'

class AvailiabilityTest < MiniTest::Unit::TestCase 
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_available_periods_of_time
    from = new_datetime 10
    to   = new_datetime 19

    reserved_periods_of_time = [
      [new_datetime( 9), new_datetime(11)],
      [new_datetime(12), new_datetime(14)],
      [new_datetime(15), new_datetime(17)],
      [new_datetime(18), new_datetime(20)]
    ]

    availability = available_periods_of_time(reserved_periods_of_time, from, to)
    assert_equal 3, availability.size
    assert_equal [new_datetime(11), new_datetime(12)], availability[0]
    assert_equal [new_datetime(14), new_datetime(15)], availability[1]
    assert_equal [new_datetime(17), new_datetime(18)], availability[2]    
  end

  def test_availability
    @resource ||= Resource.create!(name: 'A name', description: 'A description')
    load_bookings(@resource)

    get availability_resource_path(@resource.id), {date: '2013-12-10', limit: 1.to_s}
    assert_status 200
    data = JSON.parse last_response.body
    availability = data['availability']
    assert_equal 3, availability.size

    period = availability.first
    assert_equal '2013-12-10', period['from']
    assert_equal '2013-12-10T12:00:00Z', period['to']

    assert_equal 'book', period['links'][0]['rel']
    assert_equal 'resource', period['links'][1]['rel']
  end

  private

  def new_datetime(hour)
    DateTime.new(2013, 12, 10, hour)
  end

  def load_bookings(resource)
    bookings = [{ start_time: new_datetime(-1) }, { start_time: new_datetime(12) }, { start_time: new_datetime(15) }, { start_time: new_datetime(23) }]
    resource.bookings.create(bookings) do |r|
      r.end_time = r.start_time + 2.hours
      r.status = 'approved'
    end
  end

end