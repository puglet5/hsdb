# frozen_string_literal: true

class ChangeUploadTagsToArtworkTags < ActiveRecord::Migration[7.0]
  def change
    rename_table :upload_tags, :artworks_tags
  end
end
