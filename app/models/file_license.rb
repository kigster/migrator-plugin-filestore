# frozen_string_literal: true

# == Schema Information
#
# Table name: file_licenses
#
#  file_content_id :bigint           not null
#  license         :jsonb            not null
#  path            :text             not null
#
class FileLicense < ApplicationRecord
  belongs_to :file_content
end
