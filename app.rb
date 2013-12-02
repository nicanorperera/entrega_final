require 'bundler'
require "sinatra"
require "sinatra/activerecord"

ENV['RACK_ENV'] = 'development'
Bundler.require :default, ENV['RACK_ENV'].to_sym

class Resource < ActiveRecord::Base
  validates :name, presence: true
end

get '/' do
  'Hello World'
end

get '/resources' do
  content_type :json
  @resources = Resource.all

  @resources.to_json
end