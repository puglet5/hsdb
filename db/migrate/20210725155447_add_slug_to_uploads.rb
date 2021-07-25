class AddSlugToUploads < ActiveRecord::Migration[6.1]
  def change
    add_column :uploads, :slug, :string
  end
end
