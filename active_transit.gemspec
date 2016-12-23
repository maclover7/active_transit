# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_transit/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_transit'
  spec.version       = ActiveTransit::VERSION
  spec.authors       = 'Jon Moss'
  spec.email         = 'me@jonathanmoss.me'

  spec.summary       = 'A unified interface to many different transit APIs.'
  spec.description   = 'A unified interface to many different transit APIs.'
  spec.homepage      = 'https://github.com/maclover7/active_transit'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport', '~> 5'
  spec.add_runtime_dependency 'nokogiri', '~> 1'
  spec.add_runtime_dependency 'rest-client', '~> 2'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
end
