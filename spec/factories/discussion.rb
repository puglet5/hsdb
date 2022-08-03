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
#  user_id     :integer
#  category_id :integer          default(2)
#  slug        :string
#  pinned      :boolean          default(FALSE)

FactoryBot.define do
  factory :discussion do
    title { 'test title' }
    content { 'test description' }
    association :user, factory: :user
    association :category, factory: :category
  end
end
