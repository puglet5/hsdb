# frozen_string_literal: true

FactoryBot.define do
  factory :upload do
    title { 'test title' }
    description { 'test description' }
    body { 'test body' }
    user_id factory: :user
    metadata { '{"test_key": "test_value"}' }
  end
end
