# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  category_name :string           not null
#  created_at    :datetime         not null
#  discussion_id :integer          indexed
#  id            :bigint           not null, primary key
#  lock_version  :integer
#  pinned        :boolean          default(FALSE)
#  slug          :string
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_categories_on_discussion_id  (discussion_id)
#
FactoryBot.define do
  factory :category do
    category_name { 'test' }
    pinned { false }
  end
end
