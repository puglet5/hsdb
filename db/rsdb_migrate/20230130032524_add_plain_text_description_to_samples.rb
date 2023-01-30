# frozen_string_literal: true

class AddPlainTextDescriptionToSamples < ActiveRecord::Migration[7.0]
  def change
    add_column :samples, :plain_text_description, :text
  end
end
