$LOAD_PATH.unshift File.expand_path( '../../lib', __FILE__ )

begin
  require 'minitest'
rescue LoadError
end
require 'minitest/autorun'
