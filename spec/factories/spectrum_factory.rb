# frozen_string_literal: true

# == Schema Information
#
# Table name: spectra
#
#  id         :bigint           not null, primary key
#  format     :integer          default("not_set"), not null
#  status     :integer          default("none"), not null
#  category   :integer          default("not_set"), not null
#  sample_id  :bigint           not null, indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  range      :integer          default("not_set"), not null
#  metadata   :jsonb            not null, indexed
#  filename   :string
#  user_id    :bigint           not null, indexed
#
# Indexes
#
#  index_spectra_on_metadata   (metadata) USING gin
#  index_spectra_on_sample_id  (sample_id)
#  index_spectra_on_user_id    (user_id)
#

FactoryBot.define do
  factory :spectrum do
    association :sample, factory: :sample, strategy: :build
    association :user, factory: :user, strategy: :build
    metadata { '{"test_key": "test_value"}' }
  end
end
