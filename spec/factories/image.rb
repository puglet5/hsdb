# frozen_string_literal: true

FactoryBot.define do
  factory :image do
    association :artwork, factory: :artwork, strategy: :build
  end
end
