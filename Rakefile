require 'bundler/setup'
require 'rake/testtask'

filedir = File.expand_path(File.dirname(__FILE__))

Dir.glob("#{filedir}/**/tasks/*.rake").each { |r| import r }

# Default test task to run everything in the "test" directory
Rake::TestTask.new(:test) do |t|
  t.libs = %w(lib test)
  t.test_files = FileList['test/**/test_*.rb']
  t.warning = false
end

# Run unit tests
Rake::TestTask.new('test:unit') do |t|
  t.libs = %w(lib test)
  t.test_files = FileList['test/unit/**/test_*.rb']
  t.warning = false
end

# Run acceptance tests
Rake::TestTask.new('test:acceptance') do |t|
  t.libs = %w(lib test)
  t.test_files = FileList['test/acceptance/**/test_*.rb']
  t.warning = false
end

task :default => :test
