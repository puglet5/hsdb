# frozen_string_literal: true

class Upload < ApplicationRecord
  include PublicActivity::Model
  include Authorship

  tracked owner: proc { |controller, _model| controller.current_user }

  has_many_attached :images
  has_many_attached :documents
  belongs_to :user
  validates :title, :description, :body, presence: true
  validate :image_type

  has_rich_text :body

  enum status: { draft: 0, active: 1, archived: 2 }

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def author?(obj)
    obj.user == self
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
