class AddSlugToReplies < ActiveRecord::Migration[6.1]
  def change
    add_column :replies, :slug, :string
  end
end
