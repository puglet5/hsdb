class ChangeCategoryIdForDiscussions < ActiveRecord::Migration[6.1]
  def change
    change_column_default :discussions, :category_id, 2
  end
end
