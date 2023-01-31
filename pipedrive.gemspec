# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pipedrive/version'

Gem::Specification.new do |gem|
  gem.name          = 'pipedrive_api_rb'
  gem.version       = Pipedrive::VERSION
  gem.authors       = ['Jan Sterba', 'Alexander Simonov']
  gem.email         = ['info@jansterba.com']
  gem.summary       = 'Pipedrive.com API Wrapper'
  gem.description   = 'Pipedrive.com API Wrapper'
  gem.homepage      = 'https://github.com/honzasterba/pipedrive_api_rb'
  gem.license       = 'MIT'

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.require_paths = ['lib']
  gem.required_ruby_version = '>=2.5'

  gem.add_dependency('activesupport', '>= 4.0.0')
  gem.add_dependency('faraday')
  gem.add_dependency('faraday-mashify')
  gem.add_dependency('hashie', '>= 3.0')
  gem.metadata['rubygems_mfa_required'] = 'true'
end
