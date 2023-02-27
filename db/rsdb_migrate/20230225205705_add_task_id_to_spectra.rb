# frozen_string_literal: true

class AddTaskIdToSpectra < ActiveRecord::Migration[7.0]
  def change
    add_column :spectra, :task_id, :string, null: true, default: nil
  end
end
