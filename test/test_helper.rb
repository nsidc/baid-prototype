require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/mini_test'
require 'rack/test'

# Tell ruby_dep gem to be quiet. Might want to turn this back on
# once the app is more mature.
ENV['RUBY_DEP_GEM_SILENCE_WARNINGS'] = '1'
ENV['RACK_ENV'] = 'test'
require_relative '../lib/app'

reporter = ENV['REPORTER'] || 'default'

case reporter
when 'default'
  Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new]
when 'progress'
  Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new]
when 'spec'
  Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]
when 'mean'
  Minitest::Reporters.use! [Minitest::Reporters::MeanTimeReporter.new]
when 'html'
  Minitest::Reporters.use! [Minitest::Reporters::HtmlReporter.new]
when 'rubymine'
  Minitest::Reporters.use! [Minitest::Reporters::RubyMineReporter.new]
else
  Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new]
end

include Rack::Test::Methods

def app
  BaidData::App
end
