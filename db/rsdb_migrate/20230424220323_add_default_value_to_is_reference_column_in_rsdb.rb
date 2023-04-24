# frozen_string_literal: true

class AddDefaultValueToIsReferenceColumnInRsdb < ActiveRecord::Migration[7.0]
  def change
    change_column_default :samples, :is_reference, from: nil, to: false
    change_column_null :samples, :is_reference, false
  end
end
