# frozen_string_literal: true
# rubocop:disable Rails/NotNullColumn
class AddUserRefToSpectra < ActiveRecord::Migration[7.0]
  def change
    add_reference :spectra, :user, null: false
  end
end
# rubocop:enable Rails/NotNullColumn
