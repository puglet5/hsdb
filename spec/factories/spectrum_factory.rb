# frozen_string_literal: true

# == Schema Information
#
# Table name: spectra
#
#  category               :integer          default("not_set"), not null
#  created_at             :datetime         not null
#  filename               :string
#  format                 :integer          default("not_set"), not null
#  id                     :bigint           not null, primary key
#  metadata               :jsonb            not null, indexed
#  plain_text_description :text
#  plain_text_equipment   :text
#  range                  :integer          default("not_set"), not null
#  sample_id              :bigint           not null, indexed
#  status                 :integer          default("none"), not null
#  task_id                :string
#  updated_at             :datetime         not null
#  user_id                :bigint           default(1), not null, indexed
#
# Indexes
#
#  index_spectra_on_metadata   (metadata) USING gin
#  index_spectra_on_sample_id  (sample_id)
#  index_spectra_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_dfa20a7cb9  (sample_id => samples.id)
#
FactoryBot.define do
  factory :spectrum do
    association :sample, factory: :sample, strategy: :build
    association :user, factory: :user, strategy: :build
    metadata { '{"test_key": "test_value"}' }
  end
end
