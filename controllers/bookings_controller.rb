#load_booking
before booking_resource_path do
  @booking = @resource.bookings.find_by(id: params[:booking_id])
  halt(404) unless @booking
end

# Show Booking
get booking_resource_path do
  @booking ? booking_to_json(@booking) : halt(404)
end

# Bookings
get bookings_resource_path do
  bookings_to_json(@resource.bookings)
end

# Make a reservation
post bookings_resource_path do
  from, to = params['from'].to_date, params['to'].to_date
  if @resource && @resource.available?(from, to)
    booking = @resource.bookings.create(start_time: from, end_time: to)
    booking_to_json(booking)
  else
    halt(404)
  end
end

# Cancel Booking
delete booking_resource_path do
  @booking.destroy ? {}.to_json : halt(404) #TODO: Do better
end

# Accept Resource
put booking_resource_path do
  if @booking.update(status: 'approved')
    resource.filtered_bookings(@booking.start_time, @booking.end_time, 'pending').destroy_all
    booking_to_json(@booking)
  else
    halt(404)
  end
end

private

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
  [] << 
  link(booking_resource_path(resource_id, id)                   ) << 
  link(resource_path(resource_id)            , :resource        ) <<
  link(booking_resource_path(resource_id, id), :accept, 'PUT'   ) <<
  link(booking_resource_path(resource_id, id), :delete, 'DELETE')
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