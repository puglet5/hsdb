# frozen_string_literal: true

class AddOwnerToSpectra < ActiveRecord::Migration[7.0]
  def change
    add_column :spectra, :owner, :string, null: false, default: ''
  end
end
