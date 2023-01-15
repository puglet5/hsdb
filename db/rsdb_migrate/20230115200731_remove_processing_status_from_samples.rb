# frozen_string_literal: true

# rubocop:disable Rails/ReversibleMigration
class RemoveProcessingStatusFromSamples < ActiveRecord::Migration[7.0]
  def change
    remove_column :samples, :processing_status
  end
end
# rubocop:enable Rails/ReversibleMigration
