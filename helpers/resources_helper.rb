module ResourcesHelper
  def serialize_resource(resource, options = {})
    links = [{rel: :self, uri: url("/resource/#{resource.id}")}]
    links << {rel: :bookings, uri: :resource_boogings_url} if options[:bookings]
    {name: resource.name, description: resource.description, links: links}
  end

  def serialize_resources(resources)
    links = [{rel: :self, uri: url("/resources")}]
    { resources: resources.map {|resource| serialize_resource(resource)},
      links: links }
  end
end 