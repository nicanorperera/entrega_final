require 'test_helper'

class ResourcesTest < MiniTest::Unit::TestCase 
  include Rack::Test::Methods

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

  def test_show_resource
    get "/resources/#{resource.id}"
    assert_equal 200, last_response.status
    data = JSON.parse last_response.body

    r = data['resource']
    assert_equal 'A name', r['name']
    assert_equal 'A description', r['description']

    get "/resources/8989898989"
    assert_equal 404, last_response.status
  end

  def test_resources
    resource
    get '/resources'
    assert_equal 200, last_response.status
    data = JSON.parse last_response.body
    r = data['resources'].first
    assert_equal 'A name', r['name']
    assert_equal 'A description', r['description']
  end

  def test_create_resource
    assert_equal 0, Resource.count
    post '/resources', {name: 'Name', description: 'Description'}
    assert_equal 1, Resource.count
    
    r = Resource.last # FIX
    assert_equal 'Name', r.name
    assert_equal 'Description', r.description
  end

  def test_update_resource
    old_resource = Resource.create(name: 'Old name', description: 'Old description')
    put "/resources/#{old_resource.id}", {resource: {name: 'New name', description: 'New description'}}
    new_resource = Resource.take
    assert_equal 'New name', new_resource.name
    assert_equal 'New description', new_resource.description
  end

  def test_delete_resource
    resource
    assert_equal 1, Resource.count
    delete "/resources/#{resource.id}"
    assert_equal 0, Resource.count
  end
end