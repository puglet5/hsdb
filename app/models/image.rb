# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id         :bigint           not null, primary key
#  artwork_id :bigint           not null, indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  range      :integer          default(0)
#  category   :integer          default("vis")
#  status     :integer          default("not_set")
#
# Indexes
#
#  index_images_on_artwork_id  (artwork_id)
#
class Image < ApplicationRecord
  include ProcessImage

  belongs_to :artwork, inverse_of: :images, touch: true

  enum status: { not_set: 0, accepted: 1, on_review: 2 }, _default: :not_set
  enum category: { vis: 0, ir: 1, uv: 2 }, _default: :vis

  has_one_attached :image do |blob|
    blob.variant :thumbnail, resize: '400x300^', crop: '400x300+0+0', format: :jpg
  end

  validates :image, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'] }

  after_commit -> { process_image self, image&.id }, on: %i[create update]
end
