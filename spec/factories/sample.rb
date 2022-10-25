# frozen_string_literal: true

# == Schema Information
#
# Table name: samples
#
#  id                :bigint           not null, primary key
#  title             :string           not null
#  user_id           :integer
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  metadata          :jsonb            not null
#  processing_status :integer          default("none")

FactoryBot.define do
  factory :sample do
    title { 'test title' }
    association :user, factory: :user, strategy: :build
    metadata { '{"test_key": "test_value"}' }
  end
end
