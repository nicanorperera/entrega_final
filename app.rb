require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

get '/' do
  'Hello World'
end
