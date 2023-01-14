# frozen_string_literal: true

class ChangeUploadMaterialsToArtworkMaterials < ActiveRecord::Migration[7.0]
  def change
    rename_table :upload_materials, :artwork_materials
  end
end
