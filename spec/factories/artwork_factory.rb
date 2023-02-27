# frozen_string_literal: true

# == Schema Information
#
# Table name: artworks
#
#  id           :bigint           not null, primary key
#  title        :string           not null
#  description  :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer          indexed
#  slug         :string
#  status       :integer          default("draft")
#  metadata     :jsonb            not null, indexed
#  date         :string
#  survey_date  :date
#  style_id     :bigint           indexed
#  lock_version :integer
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
#  fk_rails_...         (style_id => styles.id)
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
