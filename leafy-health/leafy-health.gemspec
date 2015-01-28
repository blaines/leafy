#-*- mode: ruby -*-

require File.expand_path( '../lib/leafy/health/version', __FILE__ )

Gem::Specification.new do |s|
  s.name = 'leafy-health'
  s.version = Leafy::Health::VERSION
  s.author = 'christian meier'
  s.email = [ 'christian.meier@lookout.com' ]
  
  s.summary = %q(provide an API to register healthchecks)
  s.homepage = 'https://github.com/lookout/leafy'
  s.description = %q()
  
  s.files = `git ls-files`.split($/)

  s.requirements << 'jar io.dropwizard.metrics:metrics-healthchecks, 3.1.0'

  s.add_runtime_dependency 'jar-dependencies', '~> 0.1.7'
  s.add_development_dependency 'rspec', '~> 3.1.0'
  s.add_development_dependency 'yard', '~> 0.8.7'
end

# vim: syntax=Ruby
