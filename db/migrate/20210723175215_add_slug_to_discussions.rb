class AddSlugToDiscussions < ActiveRecord::Migration[6.1]
  def change
    add_column :discussions, :slug, :string
  end
end
