class ChangeColumnNameForCategories < ActiveRecord::Migration[6.1]
  def change
    rename_column :categories, :category, :categoty_name
  end
end
