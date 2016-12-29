desc 'List all routes'
task :routes do
  require_relative '../lib/app'
  root_path = File.expand_path('../..', __FILE__)

  Mediator::App.middleware.each do |controller|
    controller[0].each_route do |r|
      print r.verb.ljust(8)
      print r.path.to_s.ljust(35) unless r.path.nil?
      r.file.slice! root_path unless r.file.nil?
      print "#{r.file} (#{r.line})\n"
    end
  end
  puts ''
end
