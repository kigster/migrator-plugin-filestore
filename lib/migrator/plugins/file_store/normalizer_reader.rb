# frozen_string_literal: true

require "colored2"
require "active_support/inflector"
require_relative "normalizer_writer"
require_relative "import_status"

module Migrator
  module Plugins
    module FileStore
      class NormalizerReader

        TARGET_TABLE_NAMES = %w[
          file_licenses
          components_file_contents
          file_contents
        ].freeze

        class << self
          def target_tables
            @target_tables ||= TARGET_TABLE_NAMES.
              map(&:camelcase).
              map(&:singularize).
              map { |n| Object.const_get(n) }.freeze
          end
        end

        # class << self
        #   def target_tables
        #     TARGET_TABLES.
        #       map(&:singularize).
        #       map(&:camelize).
        #       map(&:constantize)
        #   end
        # end

        attr_accessor :current_batch,
                      :current_record,
                      :options,
                      :import_status

        def initialize(import_status: nil, **opts)
          self.current_record = 0
          self.current_batch  = 0
          self.options        = opts
          self.import_status     = import_status
          truncate! if opts[:truncate]
        end

        def truncate!
          TARGET_TABLES.each do |table|
            logger.info("truncating table [#{table}] -> BEGIN")
            connection.execute("truncate #{table} cascade")
            logger.info("truncating table [#{table}] -> DONE")
          end
        end

        def migrate
          each do |record|
            import_status.record_read(record)
            self.current_record += 1
          end
        end

        def each(**opts)
          each_batch(**opts) do |batch|
            batch.each do |r|
              if block_given?
                yield(r)
              end
            end
          end
        end

        # **opts:
        #   start: nil, finish: nil, batch_size: 1000, error_on_ignore: nil, order: :asc)
        #
        def each_batch(**opts)
          ::FilePath.find_in_batches(**opts) do |batch|
            if block_given?
              self.current_batch += 1
              yield(batch)
            end
          end
        end

        include Enumerable

        protected

        def log_error(e, record)
          logger.error("ERROR importing record: #{record}")
          logger.error("EXCEPTION: #{e.inspect.bold.red}")
        end
      end
    end
  end
end
