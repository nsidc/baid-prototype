require_relative '../test_helper.rb'

# Tests for general application setup.
class TestApp < Minitest::Test
  def test_config_file_loads
    get '/'
  end
end
