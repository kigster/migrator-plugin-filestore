# frozen_string_literal: true

require 'spec_helper'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

require "migrator/plugins/file_store/version"

# Load any of our adapters and extensions early in the process
require 'rspec/rails'

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.use_transactional_fixtures = true
end

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

