# frozen_string_literal: true

# == Schema Information
#
# Table name: artworks
#
#  id           :bigint           not null, primary key
#  title        :string           not null
#  description  :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#  slug         :string
#  status       :integer          default("draft")
#  metadata     :jsonb            not null
#  date         :string
#  survey_date  :date
#  style_id     :bigint
#  lock_version :integer
#
class ArtworkSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :first_name, :last_name
  end

  class StyleSerializer < ActiveModel::Serializer
    attributes :id, :name
  end

  class ImageSerializer < ActiveModel::Serializer
    attributes :id, :range, :category, :status
  end

  attributes :id, :title, :description, :status, :metadata, :date, :survey_date

  belongs_to :user,  serializer: UserSerializer
  belongs_to :style, serializer: StyleSerializer

  has_many :images, key: :images_count do
    object.images.count
  end

  has_many :tags

  has_many :materials, key: :materials_count do
    object.materials.count
  end

  has_many :images, serializer: ImageSerializer
end
