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
#
class Discussion < ApplicationRecord
  include Authorship

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
