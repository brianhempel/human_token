# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'human_token/version'

Gem::Specification.new do |spec|
  spec.name          = "human_token"
  spec.version       = HumanToken::VERSION
  spec.authors       = ["Brian Hempel"]
  spec.email         = ["plasticchicken@gmail.com"]
  spec.summary       = %q{Tokens for humans: no ambiguous characters! Sensible and configurable.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/brianhempel/human_token"
  spec.license       = "Public Domain"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "base_x", "~> 0.8.0"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
