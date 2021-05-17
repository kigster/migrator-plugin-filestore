# frozen_string_literal: true

# == Schema Information
#
# Table name: components_file_contents
#
#  component_id    :uuid             not null
#  file_content_id :bigint           not null
#
# Indexes
#
#  index_components_file_contents  (component_id,file_content_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (file_content_id => file_contents.id)
#
class ComponentsFileContent < ApplicationRecord
  belongs_to :file_content
end
