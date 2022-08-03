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
#
FactoryBot.define do
  factory :upload do
    title { 'test title' }
    description { 'test description' }
    body { 'test body' }
    association :user, factory: :user, strategy: :build
    metadata { '{"test_key": "test_value"}' }
  end
end
