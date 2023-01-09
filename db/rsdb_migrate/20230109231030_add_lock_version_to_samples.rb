# frozen_string_literal: true

class AddLockVersionToSamples < ActiveRecord::Migration[7.0]
  def change
    add_column :samples, :lock_version, :integer
  end
end
