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

ActiveRecord::Schema[7.0].define(version: 20_230_114_120_031) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pg_trgm'
  enable_extension 'plpgsql'

  create_table 'action_text_rich_texts', force: :cascade do |t|
    t.string 'name', null: false
    t.text 'body'
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[record_type record_id name], name: 'index_action_text_rich_texts_uniqueness', unique: true
  end

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', precision: nil, null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness', unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum'
    t.datetime 'created_at', precision: nil, null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'activities', force: :cascade do |t|
    t.string 'trackable_type'
    t.bigint 'trackable_id'
    t.string 'owner_type'
    t.bigint 'owner_id'
    t.string 'key'
    t.text 'parameters'
    t.string 'recipient_type'
    t.bigint 'recipient_id'
    t.datetime 'created_at', precision: nil, null: false
    t.datetime 'updated_at', precision: nil, null: false
    t.index %w[owner_id owner_type], name: 'index_activities_on_owner_id_and_owner_type'
    t.index %w[owner_type owner_id], name: 'index_activities_on_owner'
    t.index %w[recipient_id recipient_type], name: 'index_activities_on_recipient_id_and_recipient_type'
    t.index %w[recipient_type recipient_id], name: 'index_activities_on_recipient'
    t.index %w[trackable_id trackable_type], name: 'index_activities_on_trackable_id_and_trackable_type'
    t.index %w[trackable_type trackable_id], name: 'index_activities_on_trackable'
  end

  create_table 'artwork_materials', force: :cascade do |t|
    t.bigint 'artwork_id', null: false
    t.bigint 'material_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['material_id'], name: 'index_artwork_materials_on_material_id'
    t.index %w[artwork_id material_id], name: 'index_artwork_materials_on_artwork_id_and_material_id', unique: true
    t.index ['artwork_id'], name: 'index_artwork_materials_on_artwork_id'
  end

  create_table 'artworks', force: :cascade do |t|
    t.string 'title', null: false
    t.text 'description', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'user_id'
    t.string 'slug'
    t.integer 'status', default: 0
    t.jsonb 'metadata', default: '{}', null: false
    t.string 'date'
    t.date 'survey_date'
    t.bigint 'style_id'
    t.integer 'lock_version'
    t.index ['metadata'], name: 'index_artworks_on_metadata', using: :gin
    t.index ['style_id'], name: 'index_artworks_on_style_id'
    t.index ['user_id'], name: 'index_artworks_on_user_id'
  end

  create_table 'artwork_tags', force: :cascade do |t|
    t.bigint 'artwork_id', null: false
    t.bigint 'tag_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['tag_id'], name: 'index_artwork_tags_on_tag_id'
    t.index %w[artwork_id tag_id], name: 'index_artwork_tags_on_artwork_id_and_tag_id', unique: true
    t.index ['artwork_id'], name: 'index_artwork_tags_on_artwork_id'
  end

  create_table 'categories', force: :cascade do |t|
    t.string 'category_name', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'discussion_id'
    t.string 'slug'
    t.boolean 'pinned', default: false
    t.index ['discussion_id'], name: 'index_categories_on_discussion_id'
  end

  create_table 'discussions', force: :cascade do |t|
    t.string 'title', null: false
    t.text 'content'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'user_id'
    t.integer 'category_id', default: 2
    t.string 'slug'
    t.boolean 'pinned', default: false
    t.index ['category_id'], name: 'index_discussions_on_category_id'
    t.index ['user_id'], name: 'index_discussions_on_user_id'
  end

  create_table 'friendly_id_slugs', force: :cascade do |t|
    t.string 'slug', null: false
    t.integer 'sluggable_id', null: false
    t.string 'sluggable_type', limit: 50
    t.string 'scope'
    t.datetime 'created_at', precision: nil
    t.index %w[slug sluggable_type scope], name: 'index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope', unique: true
    t.index %w[slug sluggable_type], name: 'index_friendly_id_slugs_on_slug_and_sluggable_type'
    t.index %w[sluggable_type sluggable_id], name: 'index_friendly_id_slugs_on_sluggable_type_and_sluggable_id'
  end

  create_table 'images', force: :cascade do |t|
    t.bigint 'artwork_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'range', default: 0
    t.integer 'category', default: 0
    t.integer 'status', default: 0
    t.index ['artwork_id'], name: 'index_images_on_artwork_id'
  end

  create_table 'materials', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_materials_on_name', unique: true
  end

  create_table 'oauth_access_tokens', force: :cascade do |t|
    t.bigint 'resource_owner_id'
    t.bigint 'application_id', null: false
    t.string 'token', null: false
    t.string 'refresh_token'
    t.integer 'expires_in'
    t.datetime 'revoked_at'
    t.datetime 'created_at', null: false
    t.string 'scopes'
    t.string 'previous_refresh_token', default: '', null: false
    t.index ['application_id'], name: 'index_oauth_access_tokens_on_application_id'
    t.index ['refresh_token'], name: 'index_oauth_access_tokens_on_refresh_token', unique: true
    t.index ['resource_owner_id'], name: 'index_oauth_access_tokens_on_resource_owner_id'
    t.index ['token'], name: 'index_oauth_access_tokens_on_token', unique: true
  end

  create_table 'oauth_applications', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'uid', null: false
    t.string 'secret', null: false
    t.text 'redirect_uri'
    t.string 'scopes', default: '', null: false
    t.boolean 'confidential', default: true, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['uid'], name: 'index_oauth_applications_on_uid', unique: true
  end

  create_table 'replies', force: :cascade do |t|
    t.text 'reply', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'discussion_id'
    t.integer 'user_id'
    t.string 'slug'
    t.index ['discussion_id'], name: 'index_replies_on_discussion_id'
    t.index ['user_id'], name: 'index_replies_on_user_id'
  end

  create_table 'roles', force: :cascade do |t|
    t.string 'name'
    t.string 'resource_type'
    t.bigint 'resource_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[name resource_type resource_id], name: 'index_roles_on_name_and_resource_type_and_resource_id'
    t.index %w[resource_type resource_id], name: 'index_roles_on_resource'
  end

  create_table 'settings', id: :serial, force: :cascade do |t|
    t.string 'var', null: false
    t.text 'value'
    t.string 'target_type', null: false
    t.integer 'target_id', null: false
    t.datetime 'created_at', precision: nil
    t.datetime 'updated_at', precision: nil
    t.index %w[target_type target_id var], name: 'index_settings_on_target_type_and_target_id_and_var', unique: true
    t.index %w[target_type target_id], name: 'index_settings_on_target_type_and_target_id'
  end

  create_table 'styles', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_styles_on_name', unique: true
  end

  create_table 'tags', force: :cascade do |t|
    t.string 'title'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at', precision: nil
    t.string 'first_name', null: false
    t.string 'last_name', null: false
    t.string 'organization'
    t.datetime 'remember_created_at', precision: nil
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at', precision: nil
    t.datetime 'last_sign_in_at', precision: nil
    t.string 'current_sign_in_ip'
    t.string 'last_sign_in_ip'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'slug'
    t.text 'bio'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  create_table 'users_roles', id: false, force: :cascade do |t|
    t.bigint 'user_id'
    t.bigint 'role_id'
    t.index ['role_id'], name: 'index_users_roles_on_role_id'
    t.index %w[user_id role_id], name: 'index_users_roles_on_user_id_and_role_id'
    t.index ['user_id'], name: 'index_users_roles_on_user_id'
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'artwork_materials', 'artworks', column: 'artwork_id'
  add_foreign_key 'artwork_materials', 'materials'
  add_foreign_key 'artworks', 'styles'
  add_foreign_key 'artworks', 'users', name: 'artworks_user_id_fk'
  add_foreign_key 'artwork_tags', 'artworks', column: 'artwork_id'
  add_foreign_key 'artwork_tags', 'tags'
  add_foreign_key 'discussions', 'categories', name: 'discussions_category_id_fk'
  add_foreign_key 'discussions', 'users', name: 'discussions_user_id_fk'
  add_foreign_key 'images', 'artworks', column: 'artwork_id'
  add_foreign_key 'oauth_access_tokens', 'oauth_applications', column: 'application_id'
  add_foreign_key 'oauth_access_tokens', 'users', column: 'resource_owner_id'
  add_foreign_key 'replies', 'discussions', name: 'replies_discussion_id_fk'
  add_foreign_key 'replies', 'users', name: 'replies_user_id_fk'
  add_foreign_key 'users_roles', 'roles', name: 'users_roles_role_id_fk'
  add_foreign_key 'users_roles', 'users', name: 'users_roles_user_id_fk'
end
