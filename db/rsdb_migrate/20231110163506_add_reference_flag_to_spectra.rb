# frozen_string_literal: true

# rubocop:disable Rails/ThreeStateBooleanColumn
class AddReferenceFlagToSpectra < ActiveRecord::Migration[7.0]
  def change
    add_column :spectra, :is_reference, :boolean, null: true, default: false
  end
end
# rubocop:enable Rails/ThreeStateBooleanColumn
