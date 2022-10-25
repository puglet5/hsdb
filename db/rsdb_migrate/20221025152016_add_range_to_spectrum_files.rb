# frozen_string_literal: true

class AddRangeToSpectrumFiles < ActiveRecord::Migration[7.0]
  def change
    add_column :spectrum_files, :range, :integer, null: false, default: 0
  end
end
