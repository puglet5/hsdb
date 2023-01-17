# frozen_string_literal: true

class AddLockVersionToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :lock_version, :integer
  end
end
