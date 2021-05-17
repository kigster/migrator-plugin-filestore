# frozen_string_literal: true

class MigrateFiles < ActiveRecord::Migration[6.1]
  def up
    Migrator::App::CustomsAgent.new.migrate
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
