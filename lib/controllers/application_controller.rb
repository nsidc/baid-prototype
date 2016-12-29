require 'rubygems'
require 'bundler'
require_relative '../helpers/status_logger'
Bundler.require

module BaidData
  # Main controller class from which all others descend.
  class ApplicationController < Sinatra::Base
    configure do
      set :root, File.expand_path('../../', __FILE__)
      set :erb, :escape_html => true

      # Log HTTP requests to stderr (this is separate from the logging
      # handled by StatusLog module)
      enable :logging
    end

    helpers do
      # Remove any query parameters not in the "allowed" white list
      def scrub(params)
        allowed = %w(state)
        params.select { |key, _value| allowed.include? key }
      end
    end

    before do
      @params = scrub(@params)
    end

    # Only used for displaying routes via Rake
    register Sinatra::AdvancedRoutes

    # Some endpoints provide multiple response (content) types
    register Sinatra::RespondWith

    # API landing page
    # Using "respond_with :home" causes a stacktrace, apparently because
    # Tilt insists on trying to load erubis rather than using built-in
    # erb. Have exhausted all configuration options that I could find.
    # To handle different response types, try:
    # get '/' do
    #   respond_to do |format|
    #     format.html { erb :home }
    #     format.json { home_content.to_json }
    #   end
    # end
    get '/', :provides => :html do
      erb :home, :locals => {
        :description => 'A prototpe REST service to deliver research data.'
      }
    end

    get '/:site/:treatment/:plot', :provides => :json do |site, treatment, plot|
      BaidData::App.time_series[site][treatment][plot].to_json
    end
  end
end
