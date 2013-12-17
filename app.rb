require 'bundler'
require "sinatra"
require "sinatra/activerecord"

ENV['RACK_ENV'] ||= 'development'
Bundler.require :default, ENV['RACK_ENV'].to_sym

Dir[File.dirname(__FILE__) + '/helpers/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each {|file| require file }

before do
  content_type :json
end

#load_resource
before '/resources/:resource_id*' do
  @resource = Resource.find_by(id: params[:resource_id])
  halt(404) unless @resource
end

get root_path do
  {message: "Welcome to my API"}.to_json
end