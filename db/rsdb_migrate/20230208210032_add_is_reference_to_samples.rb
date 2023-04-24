# frozen_string_literal: true

# rubocop:disable Rails/ThreeStateBooleanColumn
class AddIsReferenceToSamples < ActiveRecord::Migration[7.0]
  def change
    add_column :samples, :is_reference, :boolean
  end
end
# rubocop:enable Rails/ThreeStateBooleanColumn
