# frozen_string_literal: true

class AddFilenameToSpectra < ActiveRecord::Migration[7.0]
  def change
    add_column :spectra, :filename, :string
  end
end
