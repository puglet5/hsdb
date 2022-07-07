class AddMetadataToUploads < ActiveRecord::Migration[7.0]
  def change
    add_column :uploads, :metadata, :jsonb, null: false, default: '{}'
    add_index :uploads, :metadata, using: :gin
  end
end
