# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

group :red_green_refactor, :halt_on_fail => true do
  # For ubuntu use http://www.webupd8.org/2014/04/configurable-notification-bubbles-for.html
  notification :libnotify, :timeout => 2, :transient => true, :append => true, :urgency => :critical

  guard 'rake', :task => 'test' do
    watch(%r{^test/(.*)\/?test_(.*)\.rb$})
    watch(%r{^lib/(.*)\.rb})          { |m| "test/unit/test_#{m[1]}.rb" }
    watch(%r{^test/test_helper\.rb$}) { 'test' }
  end

  guard :rubocop, :all_on_start => true, :cli => ['--format', 'emacs', '--rails'] do
    watch(/.+\.(rb|rake)/)
    watch(/(Guard|Rake)file/)
    watch(%r{(?:.+\/)?\.rubocop\.yml}) { |m| File.dirname(m[0]) }
  end
end
