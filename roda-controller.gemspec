# coding: utf-8
lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'roda/plugins/controller/version'

Gem::Specification.new do |spec|
  spec.name          = "roda-controller"
  spec.version       = Roda::RodaPlugins::Controller::VERSION
  spec.authors       = ["Amadeus Folego"]
  spec.email         = ["amadeusfolego@gmail.com"]

  spec.summary       = %q{Adds controller functionality to Roda}
  spec.description   = %q{Adds controller functionality to Roda}
  spec.homepage      = "https://github.com/badosu/roda-controller"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "roda", "~> 2.0"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "rack-test", "~> 0.6.3"
  spec.add_development_dependency "pry"
end
