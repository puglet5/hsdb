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
#
class Image < ApplicationRecord
  belongs_to :upload, inverse_of: :images, touch: true

  has_one_attached :image

  validates :image, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'] }
end
