# frozen_string_literal: true

class AddFieldsToSamples < ActiveRecord::Migration[7.0]
  # rubocop:disable Rails/BulkChangeTable
  def change
    add_column :samples, :cas_no, :string
    add_column :samples, :cas_name, :string
    add_column :samples, :common_names, :string
    add_column :samples, :compound, :string
    add_column :samples, :color, :string
    add_column :samples, :formula, :string
    add_column :samples, :location, :string
    add_column :samples, :survey_date, :date
  end
  # rubocop:enable Rails/BulkChangeTable
end
