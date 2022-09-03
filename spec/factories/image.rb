# frozen_string_literal: true

FactoryBot.define do
  factory :image do
    association :upload, factory: :upload, strategy: :build
  end
end
