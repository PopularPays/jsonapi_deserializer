# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsonapi_deserializer/version'

Gem::Specification.new do |spec|
  spec.name          = "jsonapi_deserializer"
  spec.version       = JSONApi::Deserializer::VERSION
  spec.authors       = ["Trek Glowacki"]
  spec.email         = ["trek@popularpays.com"]

  spec.summary       = "Deserialize your json-api payloads into easy-to-use hashes with attribute properties."
  spec.homepage      = "https://github.com/PopularPays/jsonapi_deserializer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.10", "< 3.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_runtime_dependency "hashie"
  spec.add_runtime_dependency "activesupport"
end
