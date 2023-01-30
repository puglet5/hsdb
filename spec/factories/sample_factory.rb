# frozen_string_literal: true

# == Schema Information
#
# Table name: samples
#
#  id                     :bigint           not null, primary key
#  title                  :string           not null
#  user_id                :integer
#  slug                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  metadata               :jsonb            not null, indexed
#  category               :integer          default("not_set"), not null
#  origin                 :string           default(""), not null
#  owner                  :string           default(""), not null
#  sku                    :string           indexed
#  cas_no                 :string
#  cas_name               :string
#  common_names           :string
#  compound               :string
#  color                  :string
#  formula                :string
#  location               :string
#  survey_date            :date
#  lock_version           :integer
#  plain_text_description :text
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
