# Show availability of a resource
get '/resources/:resource_id/availability' do
  from = params['date'].to_date
  to = from + (params['limit'] ? params['limit'].to_i : 30).days
  reserved = @resource.filtered_bookings(from, to, 'approved').pluck(:start_time, :end_time)
  periods = available_periods_of_time(reserved, from, to)
end

private

def available_periods_of_time(reserved_periods_of_time, from, to)
  xs = [from] + reserved_periods_of_time.flatten + [to]
  xs.each_slice(2).to_a.select {|f, t| f < t}
end

def periods_to_json(resource, periods)
  {availability: periods.map {|from, to| period_to_hash(resource.id, from, to)}}.to_json
end

def period_to_hash(resource_id, from, to)
  links = [{rel: :book, uri: url("resource/#{resource_id}/bookings", method: 'POST')}]
  links << {rel: :resource, uri: url("/resource/#{resource_id}")}
  {from: from, to: to, links: links}
end