class ChangeColumnNameForCategories < ActiveRecord::Migration[6.1]
  def change
    rename_column :categories, :categoty_name, :category_name
  end
end
