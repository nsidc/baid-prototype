desc 'Run via local puma server'
task :run do
  # require gems here to avoid conflicts between rake and sinatra-contrib
  Bundler.require
  sh 'puma config.ru'
end
