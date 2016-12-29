require_relative '../test_helper.rb'

# Tests for methods to harvest metadata records
class TestHarvestHandler < MiniTest::Test
  def test_production_url_is_simple
    BaidData::App.stub :harvest, 'base_url' => 'cu.edu', 'prefix' => '' do
      ENV['HARVEST_ENV'] = 'production'
      handler = BaidData::HarvestHandler.new
      assert_equal 'cu.edu', handler.base_url

      ENV['HARVEST_ENV'] = nil
      handler = BaidData::HarvestHandler.new
      assert_equal 'cu.edu', handler.base_url
    end
  end

  def test_uses_config_file
    ENV['HARVEST_ENV'] = nil
    handler            = BaidData::HarvestHandler.new(:base_url => 'cu.edu')
    assert_equal 'staging.cu.edu', handler.base_url

    ENV['HARVEST_ENV'] = ' '
    handler            = BaidData::HarvestHandler.new(:base_url => 'cu.edu')
    assert_equal 'staging.cu.edu', handler.base_url
  end

  def test_uses_environment_variable
    ENV['HARVEST_ENV'] = 'integration'
    handler            = BaidData::HarvestHandler.new(:base_url => 'cu.edu')
    assert_equal 'integration.cu.edu', handler.base_url
  end

  def test_uses_app_environment
    ENV['HARVEST_ENV'] = nil
    BaidData::App.stub :harvest, 'base_url' => 'cu.edu', 'prefix' => nil do
      handler = BaidData::HarvestHandler.new
      assert_equal 'test.cu.edu', handler.base_url
    end
  end

  def test_failed_harvest_is_intercepted
    OAI::Client.any_instance.stubs(:get_record).returns('')
    assert_raises(ArgumentError) do
      BaidData::HarvestHandler.new.metadata_content
    end
  end
end
