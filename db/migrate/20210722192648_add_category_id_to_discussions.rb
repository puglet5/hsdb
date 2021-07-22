class AddCategoryIdToDiscussions < ActiveRecord::Migration[6.1]
  def change
    add_column :discussions, :category_id, :integer
  end
end
