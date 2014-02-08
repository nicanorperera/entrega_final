ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app', __FILE__
require 'json'

def assert_status(status)
  assert_equal status, last_response.status
end