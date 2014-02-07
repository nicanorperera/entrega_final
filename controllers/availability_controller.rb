# Show availability of a resource
get availability_resource_path do
  puts 'AAA', 'AAA', 'AAA', 'AAA', params, 'AAA', 'AAA', 'AAA', 'AAA'
  from   = params['date'] ? params['date'].to_date : (Date.today + 1.day)
  to     = from + (params['limit'] ? params['limit'].to_i : 30)
  reserved = @resource.filtered_bookings(from, to, 'approved').pluck(:start_time, :end_time)
  periods = available_periods_of_time(reserved, from.to_date, to.to_date) #DateTime.iso8601(
  periods_to_json(@resource, periods)
end

private

def available_periods_of_time(reserved_periods_of_time, from, to)
  xs = [from] + reserved_periods_of_time.flatten + [to]
  xs.each_slice(2).select {|f, t| f < t} 
end

def periods_to_json(resource, periods)
  {availability: periods.map {|from, to| period_to_hash(resource.id, from, to)}}.to_json
end

def period_to_hash(resource_id, from, to)
  links = [link(bookings_resource_path(resource_id), :book, 'POST'), link(resource_path(resource_id), :resource)]
  {from: from, to: to, links: links}
end