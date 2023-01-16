# frozen_string_literal: true

# == Schema Information
#
# Table name: discussions
#
#  id          :bigint           not null, primary key
#  title       :string           not null
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          indexed
#  category_id :integer          default(2), indexed
#  slug        :string
#  pinned      :boolean          default(FALSE)
#
# Indexes
#
#  index_discussions_on_category_id  (category_id)
#  index_discussions_on_user_id      (user_id)
#

FactoryBot.define do
  factory :discussion do
    title { 'test title' }
    content { 'test description' }
    association :user, factory: :user
    association :category, factory: :category
  end
end
