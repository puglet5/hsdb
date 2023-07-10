# frozen_string_literal: true

# == Schema Information
#
# Table name: discussions
#
#  category_id  :integer          default(2), indexed
#  content      :text
#  created_at   :datetime         not null
#  id           :bigint           not null, primary key
#  lock_version :integer
#  pinned       :boolean          default(FALSE)
#  slug         :string
#  title        :string           not null
#  updated_at   :datetime         not null
#  user_id      :integer          indexed
#
# Indexes
#
#  index_discussions_on_category_id  (category_id)
#  index_discussions_on_user_id      (user_id)
#
# Foreign Keys
#
#  discussions_category_id_fk  (category_id => categories.id)
#  discussions_user_id_fk      (user_id => users.id)
#
FactoryBot.define do
  factory :discussion do
    title { 'test title' }
    content { 'test description' }
    association :user, factory: :user
    association :category, factory: :category
  end
end
