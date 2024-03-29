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
class Discussion < ApplicationRecord
  include Authorship

  acts_as_favoritable

  belongs_to :category
  belongs_to :user
  has_many :replies, dependent: :destroy

  has_rich_text :content

  validates :title, :content, presence: true
  validates :content, length: { minimum: 5 }

  resourcify

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
