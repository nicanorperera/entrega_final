require 'bundler'
require "sinatra"
require "sinatra/activerecord"

ENV['RACK_ENV'] ||= 'development'
Bundler.require :default, ENV['RACK_ENV'].to_sym

require_relative 'helpers/resources_helper.rb'
include ResourcesHelper

class Resource < ActiveRecord::Base
  validates :name, presence: true
end

get '/' do
  if settings.development?
    "development"
  else
    "test"
  end
end

# Show a Resource
get '/resources/:id' do
  content_type :json
  @resource = Resource.find(params[:id])

  if @resource
    {resource: serialize_resource(@resource, {bookings: true})}.to_json
  else
    halt 404
  end
end

# Index
get '/resources' do
  content_type :json
  @resources = Resource.all

  serialize_resources(@resources).to_json
end

# Create a Resource
post '/resources' do
  content_type :json

  @resource = Resource.new(params)

  if @resource.save
    {resource: serialize_resource(@resource)}.to_json
  else
    halt 500
  end
end

# Update a Resource
put '/resources/:id' do
  content_type :json

  @resource = Resource.find(params[:id])
  @resource.update(params['resource'])

  if @resource.save
    @resource.to_json
  else
    halt 500
  end
end

# Delete a Resource
delete '/resources/:id/delete' do
  content_type :json
  @resource = Resource.find(params[:id])

  if @resource.destroy
    {:success => "ok"}.to_json
  else
    halt 500
  end
end