# Show a Resource
get '/resources/:resource_id' do
  @resource ? resource_to_json(@resource) : halt(404)
end

# Index
get '/resources' do
  @resources = Resource.all
  resources_to_json(@resources)
end

# Create a Resource
post '/resources' do
  @resource = Resource.new(params)
  @resource.save ? resource_to_json(@resource) : halt(500)
end

# Update a Resource
put '/resources/:resource_id' do
  if @resource.update(params['resource'])
    resource_to_json(@resource)
  else
    halt 500
  end
end

# Delete a Resource
delete '/resources/:resource_id' do
  if @resource.destroy
    {:success => "ok"}.to_json
  else
    halt 500
  end
end

private

def resource_to_json(resource)
  {resource: resource_to_hash(resource, {bookings: true})}.to_json
end

def resources_to_json(resources)
  links = [{rel: :self, uri: url("/resources")}]
  resources.map! {|resource| resource_to_hash(resource)}
  {resources: resources, links: links}.to_json
end

def resource_to_hash(resource, options = {})
  links = [{rel: :self, uri: url("/resource/#{resource.id}")}]
  links << {rel: :bookings, uri: :resource_boogings_url} if options[:bookings]
  {name: resource.name, description: resource.description, links: links}
end