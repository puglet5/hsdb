# frozen_string_literal: true

# == Schema Information
#
# Table name: artworks
#
#  created_at   :datetime         not null
#  date         :string
#  description  :text             not null
#  id           :bigint           not null, primary key
#  lock_version :integer
#  metadata     :jsonb            not null, indexed
#  slug         :string
#  status       :integer          default("draft")
#  style_id     :bigint           indexed
#  survey_date  :date
#  title        :string           not null
#  updated_at   :datetime         not null
#  user_id      :integer          indexed
#
# Indexes
#
#  index_artworks_on_metadata  (metadata) USING gin
#  index_artworks_on_style_id  (style_id)
#  index_artworks_on_user_id   (user_id)
#
# Foreign Keys
#
#  artworks_user_id_fk  (user_id => users.id)
#  fk_rails_a8cd17dcba  (style_id => styles.id)
#
class Artwork < ApplicationRecord
  include Authorship
  include CustomValidations
  include ParseMetadata
  include ProcessImage
  include ArTransactionChanges

  acts_as_favoritable

  scope :by_status, ->(status) { where(status: status) }
  scope :with_images, -> { where.associated(:images) }
  scope :with_no_images, -> { where.missing(:images) }

  # dates are passed in ISO 8601 format, i.e. YYYY-MM-DD.
  scope :by_survey_period, ->(start_date, end_date) { where('survey_date BETWEEN ? and ?', start_date, end_date) }
  scope :by_created_at_period, ->(start_date, end_date) { where('created_at BETWEEN ? and ?', start_date, end_date) }

  has_many :images, inverse_of: :artwork, dependent: :destroy
  accepts_nested_attributes_for :images, reject_if: proc { |attributes| attributes['image'].blank? }
  has_many :image_attachments, through: :images

  has_one_attached :thumbnail do |blob|
    blob.variant :thumbnail, resize: '400x300^', crop: '400x300+0+0', format: :jpg
    blob.variant :banner, resize: '1600x900^', crop: '1600x900+0+0', format: :jpg
  end

  has_many_attached :documents

  has_many :artwork_tags, dependent: :destroy
  has_many :tags, through: :artwork_tags

  has_many :artwork_materials, dependent: :destroy
  has_many :materials, through: :artwork_materials

  belongs_to :style, optional: true, touch: true

  belongs_to :user
  validates :title, :description, presence: true

  has_rich_text :body

  enum status: { draft: 0, active: 1, archived: 2 }, _default: :draft

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  after_commit :parse_metadata, on: %i[create update]
  after_commit -> { process_image self, thumbnail&.id }, on: %i[create update], unless: -> { transaction_changed_attributes.keys == ['updated_at'] }

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def image_count
    images&.count.to_i
  end

  def has_images?
    image_count.positive?
  end
end
