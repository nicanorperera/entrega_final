# Load Booking
before booking_resource_path do
  @resource ||= Resource.find_by(id: params[:resource_id])
  @booking = @resource.bookings.find_by(id: params[:booking_id])
  halt(404) unless @booking
end

# Show Booking
get booking_resource_path do
  @booking ? booking_to_json(@booking) : halt(404)
end

# Bookings
get bookings_resource_path do
  from   = params['date'] ? params['date'].to_date : (Date.today + 1.day)
  to     = from + (params['limit'].to_i || 30)
  params['status'] ||= 'approved'
  status = params['status'] if ['pending', 'approved'].include? params['status']
  bookings_to_json(@resource.filtered_bookings(from, to, status))
end

# Make a reservation
post bookings_resource_path do
  from, to = params['from'].to_date, params['to'].to_date
  if @resource && @resource.available?(from, to)
    status 201
    booking = @resource.bookings.create(start_time: from, end_time: to, status: 'pending')
    booking_to_json(booking)
  else
    halt(409) # 409 Conflict
  end
end

# Cancel Booking
delete booking_resource_path do
  @booking.destroy ? {}.to_json : halt(404) #TODO: Do better
end

# Authorize Resource
put booking_resource_path do
  if @resource.available?(@booking.start_time, @booking.end_time)
    if @booking.update(status: 'approved')
      @resource.filtered_bookings(@booking.start_time, @booking.end_time, 'pending').destroy_all
      booking_to_json(@booking)
    else
      halt(404)
    end
  else
    halt(409)
  end
end


def bookings_to_json(bookings)
  links = [{rel: :self, uri: request.url}]
  {book: bookings.map {|booking| booking_to_hash(booking)}, links: links}.to_json
end

def booking_to_json(booking)
  booking_to_hash(booking).to_json
end

def booking_to_hash(booking)
  {
    from:   booking.start_time, 
    to:     booking.end_time, 
    status: booking.status, 
    links:  booking_links(booking.resource.id, booking.id) 
  }
end

def booking_links(resource_id, id)
  [
    link(booking_resource_path(resource_id, id)),
    link(resource_path(resource_id), :resource),
    link(booking_resource_path(resource_id, id), :accept, 'PUT'),
    link(booking_resource_path(resource_id, id), :reject, 'DELETE')
  ] 
end

#  "from": "2013-11-12T00:00:00Z",
#  "to": "2013-11-13T11:00:00Z",
#  "status": "pending",
#  "links": [
#    {
#      "rel": "self",
#      "url": "http://localhost:9292/resources/1/bookings/#ID_CREADO#"
#    },
#    {
#      "rel": "resource",
#      "uri": "http://localhost:9292/resource/1",
#    },
#    {
#      "rel": "accept",
#      "uri": "http://localhost:9292/resource/1/bookings/#ID_CREADO#",
#      "method": "PUT"
#    },
#    {
#      "rel": "reject",
#      "uri": "http://localhost:9292/resource/1/bookings/#ID_CREADO#",
#      "method": "DELETE"
#    }
#  ]