# frozen_string_literal: true

class AddFilesIndexes < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  # Original Table "file
  # Replicating in this application that that we have a similar data strategy.
  #
  # Table "public.files"
  #                 Column                | Type  | Collation | Nullable | Default
  # --------------------------------------+-------+-----------+----------+---------
  #  component_id                         | uuid  |           | not null |
  #  file_path                            | text  |           | not null |
  #  fingerprint_sha_256                  | bytea |           | not null |
  #  fingerprint_comment_stripped_sha_256 | bytea |           |          |
  #  license_info                         | json  |           |          |
  # --------------------------------------+-------+-----------+----------+---------
  #
  # Indexes:
  #   "files_pkey" PRIMARY KEY, btree
  #     (component_id, file_path)
  #   "files_fingerprint_comment_stripped_sha_256_idx" btree
  #     (fingerprint_comment_stripped_sha_256)
  #   "files_fingerprint_sha_256_idx" btree
  #     (fingerprint_sha_256)
  def change
    add_index :files,
              %i(component_id file_path),
              unique: true

    add_index :files,
              :fingerprint_sha_256

    add_index :files,
              :fingerprint_comment_stripped_sha_256,
              where: 'fingerprint_comment_stripped_sha_256 is not null'

    add_index :files,
              :component_id,
              where: 'license_info is not null'
  end
end
