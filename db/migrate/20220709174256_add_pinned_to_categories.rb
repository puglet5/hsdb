class AddPinnedToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :pinned, :boolean, default: false
  end
end
