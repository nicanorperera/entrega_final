# Show a Resource
get resource_path do
  resource_to_json(@resource)
end

# Index
get resources_path do  
  resources_to_json(Resource.all)
end

# Create a Resource
post resources_path do
  @resource = Resource.new(params)
  @resource.save ? resource_to_json(@resource) : halt(500)
end

# Update a Resource
put resource_path do
  @resource.update(params['resource']) ? resource_to_json(@resource) : halt(500)
end

# Delete a Resource
delete resource_path do
  @resource.destroy ? {}.to_json : halt(500)
end

private

def resource_to_json(resource)
  {resource: resource_to_hash(resource, {bookings: true})}.to_json
end

def resources_to_json(resources)
  resources.map! {|resource| resource_to_hash(resource)}
  {resources: resources, links: [link(resources_path)]}.to_json
end

def resource_to_hash(resource, options = {})
  links = [] << link(resource_path(resource.id))
  links << link(bookings_resource_path(resource.id), :bookings) if options[:bookings]

  {name: resource.name, description: resource.description, links: links}
end