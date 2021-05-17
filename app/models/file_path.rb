# frozen_string_literal: true

# == Schema Information
#
# Table name: files
#
#  component_id                         :uuid             not null, primary key
#  file_path                            :text             not null
#  fingerprint_sha_256                  :binary           not null
#  fingerprint_comment_stripped_sha_256 :binary
#  license_info                         :json
#
# Indexes
#
#  index_files_on_component_id_and_file_path            (component_id,file_path) UNIQUE
#  index_files_on_fingerprint_comment_stripped_sha_256  (fingerprint_comment_stripped_sha_256) WHERE (fingerprint_comment_stripped_sha_256 IS NOT NULL)
#  index_files_on_fingerprint_sha_256                   (fingerprint_sha_256)
#
#

class FilePath < ApplicationRecord
  include FastCounterConcern

  class << self
    include FastCounterConcern
  end

  self.table_name  = "files"
  self.primary_key = [:component_id, :file_path]

  # This is our source table, so we never want to insert into it.
  def readonly?
    !new_record?
  end

  def migrate(import_status: ::Migrator::Plugins::FileStore::ImportStatus.new(todo: fast_counter), **opts)
    ::Migrator::Plugins::FileStore::NormalizerWriter.new(file: self, import_status: import_status, **opts)
  end
end
