# frozen_string_literal: true

ENV["RUBYOPT"] = "-W0"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "rspec"
require "rspec/its"
require "simplecov"

SimpleCov.start do
  add_filter "spec/"
end

require 'rspec-benchmark'

RSpec.configure do |config|
  config.include RSpec::Benchmark::Matchers
end

require "migrator/plugins/file_store"

RSpec.configure do |spec|
  spec.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  spec.raise_errors_for_deprecations!

  spec.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end

::Dir.glob(::File.expand_path("../support/**/*.rb", __FILE__)).each { |f| require(f) }
