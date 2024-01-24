# frozen_string_literal: true

require_relative "lib/mermaid/version"

Gem::Specification.new do |spec|
  spec.name = "mermaid"
  spec.version = Mermaid::VERSION
  spec.authors = ["Abdelkader Boudih"]
  spec.email = ["terminale@gmail.com"]

  spec.summary = "Generate Diagrams and Flowcharts with Mermaid"
  spec.description = spec.summary
  spec.homepage = 'https://github.com/seuros/mermaid-ruby'
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = 'https://github.com/seuros/mermaid-ruby/blob/master/CHANGELOG.md'

  spec.files = Dir.glob("{app,config,db,lib}/**/*") + %w[CHANGELOG.md LICENSE.txt README.md Rakefile]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "zeitwerk"
  spec.add_runtime_dependency "dry-types", "~> 1.7"
  spec.add_runtime_dependency "dry-struct", "~> 1.6"
end
