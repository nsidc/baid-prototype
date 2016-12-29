# Ensure that a default home value is set in the VM environment
ENV['HOME'] ||= '/opt/prototype'

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'app'

run BaidData::App
