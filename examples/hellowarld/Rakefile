#-*- mode: ruby -*-

require 'maven/ruby/maven'

task :default do
  mvn = Maven::Ruby::Maven.new
  mvn.property 'jruby.version', JRUBY_VERSION
  if mvn.verify
    puts "\n\ndone ok\n\n"
  else
    raise "\n\nintegration test failed\n\n"
  end
end
