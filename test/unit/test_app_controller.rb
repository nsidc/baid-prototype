require_relative '../test_helper.rb'

# Tests for general application setup.
class TestApp < Minitest::Test
  def test_params_are_scrubbed
    allowed = { 'state' => 'draft' }
    attempted = { 'sky' => 'blue',
                  'state' => 'draft' }
    assert allowed.eql? BaidData::ApplicationController.new.helpers.scrub(attempted)
  end
end
