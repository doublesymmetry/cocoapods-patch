# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods_patch.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-patch'
  spec.version       = CocoapodsPatch::VERSION
  spec.authors       = ['Double Symmetry']
  spec.email         = ['dev@doublesymmetry.com']
  spec.description   = 'Create & apply patches to Pods'
  spec.summary       = 'Create & apply patches to Pods'
  spec.homepage      = 'https://github.com/DoubleSymmetry/cocoapods-patch'
  spec.license       = 'MIT'

  spec.files         = Dir['*.md', 'lib/**/*', 'LICENSE']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency "cocoapods", "~> 1.12.0"

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
end
