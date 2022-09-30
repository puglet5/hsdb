# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id         :bigint           not null, primary key
#  upload_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  range      :integer          default(0)
#  category   :integer          default("vis")
#  status     :integer          default("not_set")
#
class Image < ApplicationRecord
  include ProcessImage

  belongs_to :upload, inverse_of: :images, touch: true

  enum status: { not_set: 0, accepted: 1, on_review: 2 }
  enum category: { vis: 0, ir: 1, uv: 2 }

  has_one_attached :image do |blob|
    blob.variant :thumbnail, resize: '400x300^', crop: '400x300+0+0', format: :jpg
  end

  validates :image, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'] }

  after_commit :process_image, on: %i[create update]
end
