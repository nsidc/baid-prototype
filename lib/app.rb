require 'rubygems'
require 'bundler'
Bundler.require

# Explicitly requiring tilt/erb here to silence autoload warnings when
# running tests.
require 'tilt/erb'
require_relative './helpers/data_store.rb'

# Load all controllers. Note! application_controller needs to be loaded first.
Dir.glob('./lib/{controllers}/*.rb').sort.each { |file| require file }

# RESTFul API to serve data associated with BAID research sites
module BaidData
  # This class simply handles the logistics of getting everything started.
  # The real work happens in ApplicationController and its subclasses.
  class App < Sinatra::Base
    register Sinatra::ConfigFile
    set :environments, %w(development integration test staging production)
    config_file File.expand_path('../../config/config.yml', __FILE__)

    # Grab some data
    set :time_series, DStore::TSeries.new(File.expand_path('./data/2008_ITEX_Barrow_Atqasuk_Detailed_Microclimate_v1.txt')).time_series
    use ApplicationController
  end

  at_exit do
    # If a log file is set up, close it here
  end
end
