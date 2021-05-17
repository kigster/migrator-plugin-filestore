# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'migrator/plugins/file_store/version'

Gem::Specification.new do |spec|
  spec.name = "migrator-plugins-filestore"
  spec.version = Migrator::Plugins::FileStore::VERSION
  spec.authors = ["FOSSA, Inc", "Konstantin Gredeskoul"]
  spec.email = %w(kigster@gmail.com)

  spec.summary = "Filestore Migrator Plugin"
  spec.license = "MIT"

  spec.description = "Uses Migrator App to perform a fast parallel migration "

  spec.homepage = "https://github.com/fossas/migrator-plugin-filestore"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3"

  # frozen_string_literal: true

  spec.add_dependency "composite_primary_keys"
  spec.add_dependency "pg", "~> 1.1"
  spec.add_dependency "uuid"
  spec.add_dependency "activerecord"
  spec.add_dependency "rails"
  spec.add_dependency "activesupport"
  spec.add_dependency "colored2", "~> 3"
  spec.add_dependency "dry-types"
  spec.add_dependency "dry-schema"
  spec.add_dependency "ruby-progressbar"
  spec.add_dependency "listen"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "rspec-benchmark"
  spec.add_development_dependency "rspec-expectations"
  spec.add_development_dependency "rspec-mocks"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "relaxed-rubocop"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "codecov"
end
