# frozen_string_literal: true

# == Schema Information
#
# Table name: spectra
#
#  id         :bigint           not null, primary key
#  format     :integer          default("not_set"), not null
#  status     :integer          default("raw"), not null
#  category   :integer          default("not_set"), not null
#  sample_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  range      :integer          default("ir"), not null
#  metadata   :jsonb            not null
#

FactoryBot.define do
  factory :spectrum do
    association :sample, factory: :sample, strategy: :build
    metadata { '{"test_key": "test_value"}' }
  end
end
