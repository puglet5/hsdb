# frozen_string_literal: true

# == Schema Information
#
# Table name: spectra
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
  factory :spectrum do
    title { 'test title' }
    user_id factory: :user
    metadata { '{"test_key": "test_value"}' }
  end
end
