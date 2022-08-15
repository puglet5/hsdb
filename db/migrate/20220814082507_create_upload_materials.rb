# frozen_string_literal: true

class CreateUploadMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :upload_materials do |t|
      t.belongs_to :upload, null: false, foreign_key: true
      t.belongs_to :material, null: false, foreign_key: true

      t.timestamps
    end

    add_index :upload_materials, %i[upload_id material_id], unique: true
  end
end
