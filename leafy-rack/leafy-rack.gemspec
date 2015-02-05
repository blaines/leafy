#-*- mode: ruby -*-

require File.expand_path( '../lib/leafy/rack/version', __FILE__ )
require File.expand_path( '../../leafy-metrics/lib/leafy/metrics/version', __FILE__ )
require File.expand_path( '../../leafy-health/lib/leafy/health/version', __FILE__ )

Gem::Specification.new do |s|
  s.name = 'leafy-rack'
  s.version = Rack::Leafy::VERSION
  s.author = 'christian meier'
  s.email = [ 'christian.meier@lookout.com' ]
  
  s.license = 'MIT'
  s.summary = %q(rack middleware to expose leafy metrics/health data and more)
  s.homepage = 'https://github.com/lookout/leafy'
  s.description = %q(rack middleware to expose leafy metrics/health data as well a ping rack and a thread-dump rack)
  
  s.files = `git ls-files`.split($/)

  s.requirements << 'jar io.dropwizard.metrics:metrics-json, 3.1.0'
  s.requirements << 'jar io.dropwizard.metrics:metrics-jvm, 3.1.0'

  s.add_runtime_dependency 'jar-dependencies', '~> 0.1.7'
  s.add_development_dependency 'rspec', '~> 3.1.0'
  s.add_development_dependency 'yard', '~> 0.8.7'
  s.add_development_dependency 'rake', '~> 10.2'
  s.add_development_dependency 'leafy-metrics', Leafy::Metrics::VERSION
  s.add_development_dependency 'leafy-health', Leafy::Health::VERSION
end

# vim: syntax=Ruby
