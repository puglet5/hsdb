# frozen_string_literal: true

# == Schema Information
#
# Table name: discussions
#
#  id           :bigint           not null, primary key
#  title        :string           not null
#  content      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer          indexed
#  category_id  :integer          default(2), indexed
#  slug         :string
#  pinned       :boolean          default(FALSE)
#  lock_version :integer
#
# Indexes
#
#  index_discussions_on_category_id  (category_id)
#  index_discussions_on_user_id      (user_id)
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
