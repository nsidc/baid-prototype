require_relative '../test_helper.rb'
require 'json'

# Unit tests for methods to communicate with CMR
class TestStatusLog < MiniTest::Test
  LOGFILE = './test_status.log'.freeze

  def setup
    @statlog = StatLog::ApiLog.new('.', 'test_status')
  end

  def teardown
    @statlog.close
    File.delete(LOGFILE)
  end

  def test_log_exists
    assert_equal(true, File.exist?(LOGFILE))
  end

  def test_log_writes_properly
    info = { :status => 200, :exception => true, :msg => 'ABC' }
    @statlog.log(info)
    e = read_first_log_entry

    assert_equal(200, e['status'])
    assert_equal(true, e['exception'])
    assert_equal('ABC', e['msg'])
    assert_includes(e, 'url')
  end

  def test_log_filters_unneeded_fields
    info = { :status => 200, :bad_field => 'abc' }
    @statlog.log(info)
    e = read_first_log_entry

    assert_includes(e, 'status')
    refute_includes(e, 'bad_field')
  end

  private

  def read_first_log_entry
    File.open(LOGFILE) do |f|
      line = f.gets
      JSON.parse(line)
    end
  end
end
