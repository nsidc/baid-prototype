require_relative '../test_helper.rb'

# Tests for application routes.
class TestRoutes < Minitest::Test
  def setup
  end

  def test_home_renders
    get '/'
    assert last_response.ok?
    assert_equal 200, last_response.status
  end
end
