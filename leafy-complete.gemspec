#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'leafy-complete'
  s.version = '0.1.0'
  s.author = 'christian meier'
  s.email = [ 'christian.meier@lookout.com' ]

  s.license = 'MIT'
  s.summary = %q('meta' gem which pulls all the leafy gems)
  s.homepage = 'https://github.com/lookout/leafy'
  s.description = %q(this gem has no code only dependencies to all the other leafy gems. it is meant as convenient way to pull in all leafy gems in one go)

  s.files = ['leafy-complete.gemspec', 'README.md', 'LICENSE']

  s.add_runtime_dependency 'leafy-metrics', '~> 0.1.0'
  s.add_runtime_dependency 'leafy-health', '~> 0.1.0'
  s.add_runtime_dependency 'leafy-rack', '~> 0.1.0'
end

# vim: syntax=Ruby
