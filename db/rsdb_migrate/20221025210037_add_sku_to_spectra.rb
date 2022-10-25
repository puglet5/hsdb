# frozen_string_literal: true

class AddSkuToSpectra < ActiveRecord::Migration[7.0]
  def change
    add_column :spectra, :sku, :string
    add_index :spectra, :sku
  end
end
