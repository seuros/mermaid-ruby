# frozen_string_literal: true

require_relative 'lib/mermaid/version'

Gem::Specification.new do |spec|
  spec.name = 'mermaid'
  spec.version = Mermaid::VERSION
  spec.authors = ['Abdelkader Boudih']
  spec.email = ['terminale@gmail.com']

  spec.summary = 'Generate Diagrams and Flowcharts with Mermaid'
  spec.description = spec.summary
  spec.homepage = 'https://github.com/seuros/mermaid-ruby'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.3.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/seuros/mermaid-ruby/blob/master/CHANGELOG.md'

  spec.files = Dir.glob('{sig,lib}/**/*') + %w[CHANGELOG.md LICENSE.txt README.md Rakefile]
  spec.require_paths = ['lib']

  spec.add_dependency 'diagram', '>= 0.3.2'
  spec.add_dependency 'zeitwerk'
  spec.metadata['rubygems_mfa_required'] = 'true'
  # Development Dependencies
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'cuprite'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'rubocop', '~> 1.59'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.34'
  spec.add_development_dependency 'rubocop-performance', '~> 1.20'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'steep'
end
