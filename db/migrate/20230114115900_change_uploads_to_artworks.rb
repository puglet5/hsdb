# frozen_string_literal: true

class ChangeUploadsToArtworks < ActiveRecord::Migration[7.0]
  def change
    rename_table :uploads, :artworks
  end
end
