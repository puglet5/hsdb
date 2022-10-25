# frozen_string_literal: true

class CreateSpectrumFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :spectrum_files do |t|
      t.integer :format, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.integer :category, null: false, default: 0
      t.references :spectrum, null: false, foreign_key: true

      t.timestamps
    end
  end
end
