class AddUserIdToUploads < ActiveRecord::Migration[6.1]
  def change
    add_column :uploads, :user_id, :integer
  end
end
