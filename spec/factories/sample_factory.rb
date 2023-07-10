# frozen_string_literal: true

# == Schema Information
#
# Table name: samples
#
#  cas_name               :string
#  cas_no                 :string
#  category               :integer          default("not_set"), not null
#  color                  :string
#  common_names           :string
#  compound               :string
#  created_at             :datetime         not null
#  formula                :string
#  id                     :bigint           not null, primary key
#  is_reference           :boolean          default(FALSE), not null
#  location               :string
#  lock_version           :integer
#  metadata               :jsonb            not null, indexed
#  origin                 :string           default(""), not null
#  owner                  :string           default(""), not null
#  plain_text_description :text
#  sku                    :string           indexed
#  slug                   :string
#  survey_date            :date
#  title                  :string           not null
#  updated_at             :datetime         not null
#  user_id                :integer
#
# Indexes
#
#  index_samples_on_metadata  (metadata) USING gin
#  index_samples_on_sku       (sku)
#
FactoryBot.define do
  factory :sample do
    title { 'test title' }
    association :user, factory: :user, strategy: :build
    metadata { '{"test_key": "test_value"}' }
  end
end
