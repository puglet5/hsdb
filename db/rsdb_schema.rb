# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_02_25_205705) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "samples", force: :cascade do |t|
    t.string "title", null: false
    t.integer "user_id"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "metadata", default: "{}", null: false
    t.integer "category", default: 0, null: false
    t.string "origin", default: "", null: false
    t.string "owner", default: "", null: false
    t.string "sku"
    t.string "cas_no"
    t.string "cas_name"
    t.string "common_names"
    t.string "compound"
    t.string "color"
    t.string "formula"
    t.string "location"
    t.date "survey_date"
    t.integer "lock_version"
    t.text "plain_text_description"
    t.boolean "is_reference"
    t.index ["metadata"], name: "index_samples_on_metadata", using: :gin
    t.index ["sku"], name: "index_samples_on_sku"
  end

  create_table "spectra", force: :cascade do |t|
    t.integer "format", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.integer "category", default: 0, null: false
    t.bigint "sample_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "range", default: 0, null: false
    t.jsonb "metadata", default: "{}", null: false
    t.string "filename"
    t.bigint "user_id", null: false
    t.text "plain_text_description"
    t.text "plain_text_equipment"
    t.string "task_id"
    t.index ["metadata"], name: "index_spectra_on_metadata", using: :gin
    t.index ["sample_id"], name: "index_spectra_on_sample_id"
    t.index ["user_id"], name: "index_spectra_on_user_id"
  end

  add_foreign_key "spectra", "samples"
end
