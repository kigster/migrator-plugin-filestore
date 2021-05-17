# frozen_string_literal: true

class CreateFileContents < ActiveRecord::Migration[6.1]
  def change
    create_table :file_contents do |t|
      t.binary :sha, null: false, limit: 32
      t.binary :sha_clean, null: true, limit: 32
    end
    add_index :file_contents, %i[sha sha_clean], unique: true
    add_index :file_contents, %i[sha_clean], where: 'sha_clean is not null'
  end
end
