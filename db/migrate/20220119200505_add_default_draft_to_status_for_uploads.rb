# frozen_string_literal: true

class AddDefaultDraftToStatusForUploads < ActiveRecord::Migration[6.1]
  def change
    change_column_default :uploads, :status, from: nil, to: 0
  end
end
