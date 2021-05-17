# frozen_string_literal: true

require "colored2"

def log_warn(msg)
  warn("\n#{msg}   ".white.on.red + "".red)
end

namespace :fossa do
  task stats: :environment do
    require "rails/code_statistics"
    ::STATS_DIRECTORIES << ["Data Migrations", "db/data"]
    ::STATS_DIRECTORIES << ["Schema Migrations", "db/migrate"]
    ::STATS_DIRECTORIES << %w[RSpecs spec/]
    CodeStatistics::TEST_TYPES << "RSpecs"
  end

  desc "Load 1M records into the FILES table"
  task import: :environment do
    if FilePath.fast_count == 1_000_000
      warn "Already imported 1M files records"
    else
      system("spec/fixtures/files/handle-files-import import")
    end
  end

  desc "Export records from the FILES table"
  task export: :environment do
    fast_count = FilePath.fast_count
    if fast_count > 0
      puts "FILES table has #{fast_count} records"
      system("spec/fixtures/files/handle-files-import export")
    else
      log_warn("FILES table has zero records, nothing to export.s")
    end
  end

  desc "Truncate FILES table"
  task truncate: [:environment] do
    require "migrator"
    puts " ✅ Truncating the normalized tables....".blue
    Migrator.clean

    puts " ✅ Importing of #{FilePath.fast_count.to_s.bold.yellow} files...".green
    puts "–————————————————————————————————————————————————————————————————\n".bold.yellow
    Migrator.new.migrate!
  end

  desc "Migrate the FILES table into Normal Form Schema."
  task normalize: [:environment, :import] do
    puts `reset`
    require "migrator"
    puts " ✅ Truncating the normalized tables....".blue
    Migrator.clean

    puts " ✅ Importing of #{FilePath.fast_count.to_s.bold.yellow} files...".green
    puts "–————————————————————————————————————————————————————————————————\n".bold.yellow
    Migrator.new.migrate!
  end
end
