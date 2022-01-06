# frozen_string_literal: true

class Upload < ApplicationRecord
  has_many_attached :images
  belongs_to :user
  validates :title, :description, :body, presence: true
  validate :image_type

  has_rich_text :body

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def thumbnail(input)
    images[input].variant(resize: '400x300^', crop: '400x300+0+0').processed
  end

  private

  def image_type
    images.each do |image|
      errors.add(:images, 'need to be JPEG or PNG') unless image.content_type.in?(%("image/jpeg image/png"))
    end
  end
end
