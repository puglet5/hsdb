# frozen_string_literal: true

class AddStatusToUploads < ActiveRecord::Migration[6.1]
  def change
    add_column :uploads, :status, :integer
  end
end
