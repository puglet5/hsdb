# frozen_string_literal: true

# == Schema Information
#
# Table name: artworks
#
#  created_at   :datetime         not null
#  date         :string
#  description  :text             not null
#  id           :bigint           not null, primary key
#  lock_version :integer
#  metadata     :jsonb            not null, indexed
#  slug         :string
#  status       :integer          default("draft")
#  style_id     :bigint           indexed
#  survey_date  :date
#  title        :string           not null
#  updated_at   :datetime         not null
#  user_id      :integer          indexed
#
# Indexes
#
#  index_artworks_on_metadata  (metadata) USING gin
#  index_artworks_on_style_id  (style_id)
#  index_artworks_on_user_id   (user_id)
#
# Foreign Keys
#
#  artworks_user_id_fk  (user_id => users.id)
#  fk_rails_a8cd17dcba  (style_id => styles.id)
#
FactoryBot.define do
  factory :artwork do
    title { 'test title' }
    description { 'test description' }
    body { 'test body' }
    association :user, factory: :user, strategy: :build
    metadata { '{"test_key": "test_value"}' }
    date { 'test string' }
    survey_date { 1.hour.ago }
    association :style, factory: :style, strategy: :build
  end
end
