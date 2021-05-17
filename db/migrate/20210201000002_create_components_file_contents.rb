# frozen_string_literal: true

class CreateComponentsFileContents < ActiveRecord::Migration[6.1]
  def change
    create_table :components_file_contents, id: false do |t|
      t.uuid :component_id, null: false
      t.bigint :file_content_id, null: false
    end

    add_index :components_file_contents,
              %i[component_id file_content_id],
              unique: true,
              name:   'index_components_file_contents'

    add_foreign_key :components_file_contents, :file_contents
  end
end
