ActiveRecord::Schema[7.0].define(version: 20_220_720_163_907) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'spectra', force: :cascade do |t|
    t.string 'title'
    t.integer 'user_id'
    t.string 'slug'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
