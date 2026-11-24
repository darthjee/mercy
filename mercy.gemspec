# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mercy/version'

Gem::Specification.new do |gem|
  gem.name                  = 'mercy'
  gem.version               = Mercy::VERSION
  gem.authors               = ['Darthjee']
  gem.email                 = ['darthjee@gmail.com']
  gem.summary               = 'Gem for easy health check'
  gem.description           = 'Gem for easy health check'
  gem.homepage              = 'https://github.com/darthjee/mercy'
  gem.required_ruby_version = '>= 3.4.0'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.require_paths = ['lib']
  gem.metadata['rubygems_mfa_required'] = 'false'

  gem.add_dependency 'activesupport',       '~> 7.2.x'
  gem.add_dependency 'arstotzka',           '>= 1.6.2'
  gem.add_dependency 'darthjee-active_ext', '>= 1.4.0'
  gem.add_dependency 'darthjee-core_ext',   '>= 3.2.0'
end
