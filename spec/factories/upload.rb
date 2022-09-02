# frozen_string_literal: true

# == Schema Information
#
# Table name: uploads
#
#  id          :bigint           not null, primary key
#  title       :string           not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  slug        :string
#  status      :integer          default("draft")
#  metadata    :jsonb            not null
#  date        :string
#  survey_date :date
#  style_id    :bigint
#
FactoryBot.define do
  factory :upload do
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
