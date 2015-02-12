#-*- mode: ruby -*-

require File.expand_path( '../lib/leafy/health/version', __FILE__ )

Gem::Specification.new do |s|
  s.name = 'leafy-health'
  s.version = Leafy::Health::VERSION
  s.author = 'christian meier'
  s.email = [ 'christian.meier@lookout.com' ]

  s.license = 'MIT'
  s.summary = %q(provides an API to register healthchecks)
  s.homepage = 'https://github.com/lookout/leafy'
  s.description = %q(provides an API to register healthchecks which uses dropwizrd-metrics-healthchecks)
  
  s.files = `git ls-files`.split($/)

  s.requirements << 'jar io.dropwizard.metrics:metrics-healthchecks, 3.1.0'

  s.add_runtime_dependency 'jar-dependencies', '~> 0.1.8'
  s.add_development_dependency 'rspec', '~> 3.1.0'
  s.add_development_dependency 'yard', '~> 0.8.7'
  s.add_development_dependency 'rake', '~> 10.2'
end

# vim: syntax=Ruby
