# frozen_string_literal: true

class AddPlainTextFieldsToSpectra < ActiveRecord::Migration[7.0]
  # rubocop:disable Rails/BulkChangeTable
  def change
    add_column :spectra, :plain_text_description, :text
    add_column :spectra, :plain_text_equipment, :text
  end
  # rubocop:enable Rails/BulkChangeTable
end
