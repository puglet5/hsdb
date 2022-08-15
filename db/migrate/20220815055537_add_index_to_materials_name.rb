# frozen_string_literal: true

class AddIndexToMaterialsName < ActiveRecord::Migration[7.0]
  def change
    add_index :materials, :name, unique: true
  end
end
