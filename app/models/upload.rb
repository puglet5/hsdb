# frozen_string_literal: true

class Upload < ApplicationRecord
  include PublicActivity::Model
  include Authorship

  tracked owner: proc { |controller, _model| controller.current_user }

  has_many_attached :images
  has_one_attached :thumbnail
  has_many_attached :documents
  has_many :upload_tags, dependent: :destroy
  has_many :tags, through: :upload_tags
  belongs_to :user
  validates :title, :description, :body, presence: true
  validate :image_type
  validate :json_validity

  has_rich_text :body

  enum status: { draft: 0, active: 1, archived: 2 }

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  after_commit :parse_json, on: %i[create update]

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  private

  def image_type
    images.each do |image|
      unless image.content_type.in?(%("image/jpeg image/png image/svg image/gif"))
        errors.add(:images,
                   'need to be JPEG or PNG')
      end
    end
  end

  def json_validity
    errors.add(:metadata, 'is not a valid JSON object') unless JSON.is_json?(metadata)
  end

  def parse_json
    parsed_json = JSON.parse(metadata) if metadata
    puts metadata
    puts parsed_json
    update_column(:metadata, parsed_json) if parsed_json
  rescue JSON::ParserError => e
    errors.add(:metadata, 'might not be a valid JSON object')
  end
end
