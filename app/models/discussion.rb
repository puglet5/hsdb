# frozen_string_literal: true

class Discussion < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :replies, dependent: :destroy

  has_rich_text :content

  validates :title, :content, presence: true

  resourcify

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  def should_generate_new_friendly_id?
    title_changed?
  end
end
