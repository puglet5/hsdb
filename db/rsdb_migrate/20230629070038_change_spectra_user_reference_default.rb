class ChangeSpectraUserReferenceDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :spectra, :user_id, 1
  end
end
