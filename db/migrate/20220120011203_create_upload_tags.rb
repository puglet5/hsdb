# frozen_string_literal: true

class CreateUploadTags < ActiveRecord::Migration[6.1]
  def change
    create_table :upload_tags do |t|
      t.belongs_to :upload, null: false, foreign_key: true
      t.belongs_to :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :upload_tags, %i[upload_id tag_id], unique: true
  end
end
