# frozen_string_literal: true

require 'rails_helper'

module Migrator
  class ImportFiles
    TEST_FILE_COUNT = 1_000_000

    # Just trying to avoid importing 1M records more than once; while in test
    module InstanceMethods
      attr_accessor :files_loaded

      def ensure_loaded
        return if Migrator::ImportFiles.files_loaded

        count = fast_counter
        if count == 0
          raise "Internal Error importing 1M testing subjects for unit testing... #{e.inspect}"
        end

        self.files_loaded = true
      end
    end

    include InstanceMethods
    extend InstanceMethods
  end
end

# RSpec.configure do |config|
#   config.before :suite do
#     Migrator::ImportFiles.ensure_loaded
#   end
# end
#
require_relative 'import_files_spec'
