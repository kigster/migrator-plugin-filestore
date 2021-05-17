# frozen_string_literal: true

class ImporterWorker
  include BaseWorker

  def perform(total:, file_path:)
    status   = ::Migrator::Progress::ParallelStatus.new(total)
    strategy = Module.const_get(strategy)
    strategy.new(file: file_path, status: status, options: options).migrate
  end
end
