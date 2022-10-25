# frozen_string_literal: true

class AddOriginToSpectra < ActiveRecord::Migration[7.0]
  def change
    add_column :spectra, :origin, :string, null: false, default: ''
  end
end
