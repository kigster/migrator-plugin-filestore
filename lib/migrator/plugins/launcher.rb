# frozen_string_literal: true

module Migrator
  module Plugins
    module FileStore
      class Launcher
        attr_accessor :argv, :reader, :writer

        def initialize(argv = ARGV.dup)
          self.reader = NormalizerReader.new
          self.writer = NormalizerWriter.new
        end
      end
    end
  end
end
