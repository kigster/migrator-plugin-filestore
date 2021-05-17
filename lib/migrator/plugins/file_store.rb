module Migrator
  module Plugin
    module FileStore
    end
  end
end

require_relative 'launcher'
require_relative 'plugin_validator'
require_relative 'file_store/import_status'
require_relative 'file_store/normalizer_reader'
require_relative 'file_store/normalizer_writer'
