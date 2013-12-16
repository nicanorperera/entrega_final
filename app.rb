require 'bundler'
require "sinatra"
require "sinatra/activerecord"

ENV['RACK_ENV'] ||= 'development'
Bundler.require :default, ENV['RACK_ENV'].to_sym

Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each {|file| require file }

before do
  content_type :json
end

before '/resources/:resource_id' do
  @resource = Resource.find_by(id: params[:resource_id])
end