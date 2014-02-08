require 'test_helper'

class ResourcesTest < MiniTest::Unit::TestCase 
  include Rack::Test::Methods
  include Sinatra::Helpers

  def app
    Sinatra::Application
  end

  def setup
    Resource.delete_all
    @resource = nil
  end

  def resource
    @resource ||= Resource.create!(name: 'A name', description: 'A description')
  end

  def test_resource_not_existence_should_return_404
    get resource_path(99999)
    assert_status 404
  end

  def test_show_resource
    get resource_path(resource.id)
    assert_status 200

    r = JSON.parse(last_response.body)['resource']

    assert_equal 'A name', r['name']
    assert_equal 'A description', r['description']

    self_link, bookings_link = r['links']

    assert_equal 'self', self_link['rel']
    assert_match resource_path(resource.id), self_link['uri']

    assert_equal 'bookings', bookings_link['rel']
    assert_match bookings_resource_path(resource.id), bookings_link['uri']
  end

  def test_resources
    resource
    get resources_path
    assert_status 200
    data = JSON.parse last_response.body

    r = data['resources'].first
    assert_equal 'A name', r['name']
    assert_equal 'A description', r['description']

    link = r['links'].first
    assert_equal 'self', link['rel']
    assert_match resources_path, link['uri']
  end

  def test_create_resource
    assert_equal 0, Resource.count
    post resources_path, {name: 'Name', description: 'Description'}
    assert_equal 1, Resource.count
    
    r = Resource.take
    assert_equal 'Name', r.name
    assert_equal 'Description', r.description
  end

  def test_update_resource
    old_resource = Resource.create(name: 'Old name', description: 'Old description')
    put resource_path(old_resource.id), {resource: {name: 'New name', description: 'New description'}}
    new_resource = Resource.take
    assert_equal 'New name', new_resource.name
    assert_equal 'New description', new_resource.description
  end

  def test_delete_resource
    resource
    assert_equal 1, Resource.count
    delete resource_path(resource.id)
    assert_equal 0, Resource.count
  end
end