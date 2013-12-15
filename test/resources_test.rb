require 'test_helper'
require 'json'

class ResourcesTest < MiniTest::Unit::TestCase 
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def teardown
    Resource.delete_all
  end

  def test_show_resource
    r = Resource.create!(name: 'A resource', description: 'A description')
    get "/resources/#{r.id}"
    assert_equal 200, last_response.status
    data = JSON.parse last_response.body
    resource = data['resource']
    assert_equal 'A resource', resource['name']
    assert_equal 'A description', resource['description']
  end

  def test_resources_if_none
    get '/resources'
    assert_equal 200, last_response.status
    data = JSON.parse last_response.body
    assert_equal [], data['resources']
    #assert_equal url('/resources'), data[:links][:url] #TODO: test this
  end

  def test_resources
    r = Resource.create!(name: 'A resource', description: 'A description')
    get '/resources'
    assert_equal 200, last_response.status
    data = JSON.parse last_response.body
    resource = data['resources'].first
    assert_equal 'A resource', resource['name']
    assert_equal 'A description', resource['description']
  end

  def test_create_resource
    assert_equal 0, Resource.count
    post '/resources', {name: 'Name', description: 'Description'}
    assert_equal 1, Resource.count
    resource = Resource.first
    assert_equal 'Name', resource.name
    assert_equal 'Description', resource.description
  end

  def test_update_resource
    r = Resource.create(name: 'Old name', description: 'Old description')
    put "/resources/#{r.id}", {resource: {name: 'New name', description: 'New description'}}
    resource = Resource.first
    assert_equal 'New name', resource.name
    assert_equal 'New description', resource.description
  end

  def test_delete_resource
    r = Resource.create(name: 'Name', description: 'Description')
    assert_equal 1, Resource.count
    delete "/resources/#{r.id}/delete"
    assert_equal 0, Resource.count
  end
end