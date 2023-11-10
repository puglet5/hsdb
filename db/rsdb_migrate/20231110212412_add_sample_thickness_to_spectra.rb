# frozen_string_literal: true

class AddSampleThicknessToSpectra < ActiveRecord::Migration[7.0]
  def change
    add_column :spectra, :sample_thickness, :float, null: true
  end
end
