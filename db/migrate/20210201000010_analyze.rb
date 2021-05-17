# frozen_string_literal: true

class Analyze < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    execute 'create extension IF NOT EXISTS "pg_stat_statements";'
    execute 'analyze verbose;'
  end

  def down
    up
  end
end
