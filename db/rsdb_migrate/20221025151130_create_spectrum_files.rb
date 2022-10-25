class CreateSpectrumFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :spectrum_files do |t|
      t.integer :format
      t.integer :status
      t.integer :category
      t.references :spectrum, null: false, foreign_key: true

      t.timestamps
    end
  end
end
