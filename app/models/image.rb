# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  artwork_id :bigint           not null, indexed
#  category   :integer          default("vis")
#  created_at :datetime         not null
#  id         :bigint           not null, primary key
#  range      :integer          default(0)
#  status     :integer          default("not_set")
#  updated_at :datetime         not null
#
# Indexes
#
#  index_images_on_artwork_id  (artwork_id)
#
# Foreign Keys
#
#  fk_rails_54bb6d10ea  (artwork_id => artworks.id)
#
class Image < ApplicationRecord
  include ProcessImage
  include ArTransactionChanges

  scope :by_status, ->(status) { where(status: status) }
  scope :by_category, ->(category) { where(category: category) }
  scope :orphaned, -> { where.missing(:artwork) }

  belongs_to :artwork, inverse_of: :images, touch: true

  enum status: { not_set: 0, accepted: 1, on_review: 2 }, _default: :not_set
  enum category: { vis: 0, ir: 1, uv: 2 }, _default: :vis

  has_one_attached :image do |blob|
    blob.variant :thumbnail, resize: '400x300^', crop: '400x300+0+0', format: :jpg
  end

  validates :image, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'] }

  after_commit -> { process_image self, image&.id }, on: %i[create update], unless: -> { transaction_changed_attributes.keys == ['updated_at'] }
end
