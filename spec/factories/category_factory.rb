# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id            :bigint           not null, primary key
#  category_name :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  discussion_id :integer          indexed
#  slug          :string
#  pinned        :boolean          default(FALSE)
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
