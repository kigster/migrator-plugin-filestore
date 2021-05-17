# frozen_string_literal: true

class CreateFileLicenses < ActiveRecord::Migration[6.1]
  def change
    create_table :file_licenses, id: false do |t|
      t.uuid :component_id, null: false
      t.json :license, null: false
      t.text :path, null: false
      t.bigint :file_content_id, null: false
    end

    add_foreign_key :file_licenses, :file_contents

    add_index :file_licenses, %i[component_id path file_content_id], name: 'index_file_licenses_composite'
    add_index :file_licenses, %i[file_content_id]
  end
end
