# frozen_string_literal: true

class CreateMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :materials do |t|
      t.string :name

      t.timestamps
    end
  end
end
