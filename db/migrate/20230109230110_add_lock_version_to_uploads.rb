class AddLockVersionToUploads < ActiveRecord::Migration[7.0]
  def change
    add_column :uploads, :lock_version, :integer
  end
end
