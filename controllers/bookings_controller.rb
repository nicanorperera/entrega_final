# Bookings from resource
get '/resources/:resource_id/bookings' do
  @resource = Resource.find(params[:resource_id])
  @bookings = @resource.bookings

  @bookings.first.to_json
end