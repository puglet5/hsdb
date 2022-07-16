# frozen_string_literal: true

class Discussion < ApplicationRecord
  include PublicActivity::Model
  include Authorship

  tracked owner: proc { |controller, _model| controller.current_user }

  belongs_to :category
  belongs_to :user
  has_many :replies, dependent: :destroy

  has_rich_text :content

  validates :title, :content, presence: true
  validates :content, length: {minimum: 5}

  resourcify

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
