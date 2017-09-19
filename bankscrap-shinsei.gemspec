# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bankscrap/shinsei/version'

Gem::Specification.new do |spec|
  spec.name          = 'bankscrap-shinsei'
  spec.version       = Bankscrap::Shinsei::VERSION
  spec.authors       = ['David Stosik']
  spec.email         = ['david.stosik+git-noreply@gmail.com']
  spec.summary       = 'Shinsei adapter for Bankscrap'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'bankscrap'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
