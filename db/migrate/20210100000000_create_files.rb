# frozen_string_literal: true

class CreateFiles < ActiveRecord::Migration[6.1]
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
    create_table :files,
                 id:        false,
                 if_exists: false do |t|
      t.uuid :component_id, null: false
      t.text :file_path, null: false
      t.binary :fingerprint_sha_256, null: false
      t.binary :fingerprint_comment_stripped_sha_256
      t.json :license_info
    end
  end
end
