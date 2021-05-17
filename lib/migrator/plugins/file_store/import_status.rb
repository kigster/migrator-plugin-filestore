require 'thread'
module Migrator

  module Plugins
    module FileStore
      #noinspection ALL
      class ImportStatus
        attr_reader :timings, :counts, :started_at, :options, :update_queue

        COUNTER_ATTRIBUTES = %i[todo queued processed imported errored skipped ]

        def initialize(todo:, **opts)
          @update_queue = Queue.new
          @options      = opts
          @timings      = {}
          @counts       = {}
          @started      = Time.now.to_f
          # These add:
          #  • queued!, processed!, imported!, errored!, skipped! etc methods
          COUNTER_ATTRIBUTES.each do |attr|
            define_singleton_method "#{attr}!" do |increment = 1|
              incr!(attr, by: increment)
            end

            define_singleton_method "#{attr}" do
              counts[attr.to_sym] ||= 0
            end

            define_singleton_method "#{attr}=" do |value|
              counts[attr.to_sym] = value
            end

            define_singleton_method "#{attr}_rate" do
              counts[attr.to_sym] / duration
            end
          end
          self.todo = todo
        end

        # submit a record for an update asynchronously, but increment the counter.

        def update(record)
          redord.tap do |r|
            queue << r
            queued!
          end
        end

        def duration
          now - started_at
        end

        def connection
          ActiveRecord::Base.connection
        end

        def with_duration(object, method, **opts, &block)
          methodan_started_at = now
          object.send(method, **opts, &block).tap do
            @timings[method.to_sym] += (now - method_started_at)
          end
        end

        def incr!(field, by: 1)

          counts[field] += by
        end

        def now
          Time.now.to_f
        end

        def rails_env_test?
          defined?(Rails) ? (Rails.env.test? || ENV['RAILS_ENV'].eql?('test')) : false
        end

        def in_a_transaction
          if rails_env_test?
            yield(self) if block_given?
          else
            connection.transaction do
              yield(self) if block_given?
            end
          end
        end
      end
    end
  end
end
