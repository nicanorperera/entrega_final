def booking_resource_path(booking_id = ':booking_id', resource_id = ':resource_id')
  File.join bookings_resource_path(resource_id), booking_id.to_s
end

def bookings_resource_path(resource_id = ':resource_id')
  File.join resource_path(resource_id), 'bookings'
end

def availability_resource_path(resource_id = ':resource_id')
  File.join resource_path(resource_id), 'availability'
end

def resource_path(resource_id = ':resource_id')
  File.join resources_path, resource_id.to_s
end

def resources_path
  File.join root_path, 'resources'
end

def root_path
  '/'
end