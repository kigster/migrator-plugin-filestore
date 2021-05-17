# frozen_string_literal: true

class ResizeFileContentsIds < ActiveRecord::Migration[6.1]
  def change
    reversible do |direction|
      direction.up do
        execute 'ALTER TABLE file_contents ALTER COLUMN ID SET DATA TYPE BIGINT'
      end
      direction.down do
        execute 'ALTER TABLE file_contents ALTER COLUMN ID SET DATA TYPE INTEGER'
      end
    end
  end
end
