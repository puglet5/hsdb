# frozen_string_literal: true

class AddProcessingMessageToSpectra < ActiveRecord::Migration[7.1]
  def change
    add_column :spectra, :processing_message, :text, null: true
  end
end
