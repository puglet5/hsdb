# frozen_string_literal: true

# == Schema Information
#
# Table name: samples
#
#  id           :bigint           not null, primary key
#  title        :string           not null
#  user_id      :integer
#  slug         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  metadata     :jsonb            not null, indexed
#  category     :integer          default("not_set"), not null
#  origin       :string           default(""), not null
#  owner        :string           default(""), not null
#  sku          :string           indexed
#  cas_no       :string
#  cas_name     :string
#  common_names :string
#  compound     :string
#  color        :string
#  formula      :string
#  location     :string
#  survey_date  :date
#  lock_version :integer
#
# Indexes
#
#  index_samples_on_metadata  (metadata) USING gin
#  index_samples_on_sku       (sku)
#
class Sample < RsdbRecord
  include Authorship
  include CustomValidations
  include ParseJson
  include ProcessImage
  include ArTransactionChanges

  acts_as_favoritable

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  scope :by_category, ->(category) { where(category: category) }
  scope :by_origin, ->(origin) { where(origin: origin) }

  # dates are passed in ISO 8601 format, i.e. YYYY-MM-DD.
  scope :by_survey_period, ->(start_date, end_date) { where('survey_date BETWEEN ? and ?', start_date, end_date) }
  scope :by_created_at_period, ->(start_date, end_date) { where('created_at BETWEEN ? and ?', start_date, end_date) }

  belongs_to :user
  has_many :spectra, inverse_of: :sample, dependent: :destroy
  has_many :file_attachments, through: :spectra
  accepts_nested_attributes_for :spectra, reject_if: proc { |attributes| attributes['file'].blank? }

  has_many_attached :documents
  has_many_attached :images do |blob|
    blob.variant :thumbnail, resize: '400x300^', crop: '400x300+0+0', format: :jpg
  end

  has_rich_text :description

  validates :title, presence: true
  validates :images, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'] }

  after_commit :parse_json, on: %i[create update]
  after_commit -> { images.each { |image| process_image self, image&.id } }, on: %i[create update], unless: -> { transaction_changed_attributes.keys == ['updated_at'] }

  enum category: { not_set: 0, ceramics: 1, pigments: 2, other: 3 }, _default: :not_set, _suffix: :category
end
