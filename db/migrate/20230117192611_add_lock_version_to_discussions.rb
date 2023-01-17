# frozen_string_literal: true

class AddLockVersionToDiscussions < ActiveRecord::Migration[7.0]
  def change
    add_column :discussions, :lock_version, :integer
  end
end
