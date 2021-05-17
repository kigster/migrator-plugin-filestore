# frozen_string_literal: true

# == Schema Information
#
# Table name: file_contents
#
#  id        :bigint           not null, primary key
#  sha       :binary           not null
#  sha_clean :binary
#
# Indexes
#
#  index_file_contents_on_sha_and_sha_clean  (sha,sha_clean) UNIQUE
#  index_file_contents_on_sha_clean          (sha_clean) WHERE (sha_clean IS NOT NULL)
#
class FileContent < ApplicationRecord
  has_many :file_licenses
  has_many :components_file_content
end
