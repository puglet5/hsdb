# frozen_string_literal: true

class AddMetadataToSpectra < ActiveRecord::Migration[7.0]
  def change
    add_column :spectra, :metadata, :jsonb, null: false, default: '{}'
    add_index :spectra, :metadata, using: :gin
  end
end
