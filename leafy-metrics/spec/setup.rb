$LOAD_PATH.unshift File.expand_path( '../../lib', __FILE__ )
require 'jar-dependencies'

# setup logging
LOG_FILE = File.expand_path( '../../pkg/log', __FILE__ )
require 'fileutils'
FileUtils.mkdir_p File.dirname( LOG_FILE )
FileUtils.rm_f( LOG_FILE )
java.lang.System.set_property( 'org.slf4j.simpleLogger.logFile', LOG_FILE )
require_jar( 'org.slf4j', 'slf4j-simple', '1.7.7' )
