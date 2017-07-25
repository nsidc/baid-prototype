require 'rubygems'
require 'bundler'
Bundler.require

module BaidData
  # Main controller class from which all others descend.
  class ApplicationController < Sinatra::Base
    configure do
      set :root, File.expand_path('../../', __FILE__)
      set :erb, :escape_html => true

      # Log HTTP requests to stderr
      enable :logging
    end

    # Only used for displaying routes via Rake
    register Sinatra::AdvancedRoutes

    # API landing page
    get '/', :provides => :html do
      erb :home, :locals => {
        :description => 'A prototpe REST service to deliver research data.',
        :project => BaidData::App.project,
        :routes => BaidData::ApplicationController.route_summary
      }
    end

    get '/:site/:treatment/:plot', :provides => :json do |site, treatment, plot|
      BaidData::App.time_series[site][treatment][plot].to_json
    end

    # Retrieve information about endpoints specified by this controller
    # @return [Array] An array of hashes containing route information
    def self.route_summary
      # Force YARD to reload this file.
      YARD::Registry.load(Dir.glob('./lib/**/application_controller.rb'), true)
      routes = YARD::Sinatra.routes.map do |r|
        { :verb      => r.http_verb,
          :http_path => r.http_path.tr("'", ''),
          :file      => r.file,
          :line      => r.line,
          :desc      => r.docstring.tr("\n", ' ') }
      end
      routes.sort_by { |r| r[:verb] }
    end
  end
end
