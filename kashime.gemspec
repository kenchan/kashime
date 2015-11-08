# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kashime/version'

Gem::Specification.new do |spec|
  spec.name          = 'kashime'
  spec.version       = Kashime::VERSION
  spec.authors       = ['Kenichi TAKAHASHI']
  spec.email         = ['kenichi.taka@gmail.com']

  spec.summary       = 'Kashime is OpenStack Network Managment tool - Alternatives neutron'
  spec.description   = 'Kashime is OpenStack Network Managment tool - Alternatives neutron'
  spec.homepage      = 'https://github.com/kenchan/kashime'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'yao'
  spec.add_dependency 'thor'
  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
end
