require 'json'
require 'fileutils'

# Module for log handling (harvest, CMR ingest status, and application status)
module StatLog
  # Base logging class. Emits default Logger format.
  class Log
    attr_reader :logger

    # Initialize the logging framework
    # @param [path] the path to the log directory
    # @param [filename] the filename to write the status info to
    def initialize(path, filename)
      # Create the directory that contains the log if necessary
      path = File.expand_path(path)
      FileUtils.mkdir_p path

      logfile      = File.open("#{path}/#{expand_file_name(filename)}", 'a')
      logfile.sync = true
      @logger      = Logger.new(logfile)

      # Set log level for this environment. Entries at this level of
      # severity and above get logged.
      level         = BaidData::App.log['level'] || 'info'
      @logger.level = Logger.const_get level.upcase
    end

    # Prepend the project name to the base name, if appropriate
    # @param [filename] the body of the filename
    def expand_file_name(filename)
      return filename if filename.eql?('null')
      filename = [filename || 'status', 'log'].join('.')
      if BaidData::App.log['prefix']
        [BaidData::App.log['prefix'], filename].join('.')
      else
        filename
      end
    end

    # Emit a log at the specified level of severity
    # @param [String] level The string version of the Logger level constant ('info', 'debug', etc.)
    # @param [String] msg The error message
    def log(level, msg)
      @logger.add(Logger.const_get(level.upcase)) { msg }
    end

    # Close and flush the status log
    def close
      @logger.close
    end
  end

  # Log API information (E.g., connections to dataset-catalog-services and CMR)
  class ApiLog < Log
    def initialize(path, file)
      file ||= 'api'
      super

      @logger.formatter = proc do |_severity, datetime, _progname, msg|
        log = { :datetime => datetime }.merge(msg).to_json
        "#{log}\n"
      end
    end

    # Create a status log entry
    # @param [Hash] the information to pass to the log message
    # @option info [String] :provider The provider used to make the request
    # @option info [String] :dataset The ID of the dataset being logged
    # @option info [String] :action The action being logged
    # @option info [String] :exception A boolean indicating there was an error making the request itself
    # @option info [String] :status The HTTP status code of the request being logged
    # @option info [String] :msg The status message of the request
    # @option info [String] :url The URL used to make the request
    # @option info [String] :body, the result body to log
    def log(info)
      info = {
        :provider  => '',
        :dataset   => '',
        :action    => '',
        :exception => false,
        :status    => 0,
        :msg       => '',
        :url       => ''
      }.merge!(info)

      # only certain fields will be included in the log; some (like :metadata) will be huge and unneeded for this log
      @logger.info(info.select { |k, _v| [:provider, :dataset, :action, :exception, :status, :msg, :url, :body].include?(k) })
    end
  end
end
