lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'roku/iap/version'

Gem::Specification.new do |spec|
  spec.name          = 'roku-iap'
  spec.version       = Roku::Iap::VERSION
  spec.authors       = ['DailyBurn']
  spec.email         = ['dev@dailyburn.com']
  spec.description   = %q{Verify and manage Roku in app purchases}
  spec.summary       = %q{Verify and manage Roku in app purchases}
  spec.homepage      = 'https://github.com/DailyBurn/roku-iap'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
end