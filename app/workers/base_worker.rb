# frozen_string_literal: true

require 'sidekiq/worker'

module BaseWorker
  class << self
    def included(base)
      base.include(::Sidekiq::Worker)

      base.instance_eval do
        class << self
          attr_accessor :delay_job_invocation
        end

        attr_accessor :delay_job_invocation, :delay_seconds

        def perform_async(*args, **opts, &block)
          if delay_job_invocation?
            perform_in(delay_seconds, *args, &block)
          else
            super(*args, **opts, &block)
          end
        end
      end
    end

    Rails.env.test? ? base.disable_execution_delay! : base.enable_execution_delay!
    base.delay_seconds = 1
  end
end
