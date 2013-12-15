require 'test_helper'

class AppTest < MiniTest::Unit::TestCase 
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_get_root
    get '/'
    assert_equal 200, last_response.status
    assert_equal 'test', last_response.body
  end

end
