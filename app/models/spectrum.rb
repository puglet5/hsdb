# frozen_string_literal: true

# == Schema Information
#
# Table name: spectra
#
#  id                :bigint           not null, primary key
#  title             :string           not null
#  user_id           :integer
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  metadata          :jsonb            not null
#  processing_status :integer          default("none")
#
class Spectrum < RsdbRecord
  include PublicActivity::Model
  include Authorship
  include CustomValidations
  include ParseJson

  tracked owner: proc { |controller, _model| controller.current_user }

  belongs_to :user
  has_many_attached :csvs
  has_many_attached :files
  has_many_attached :processed_csvs
  has_many_attached :documents
  has_many_attached :images
  has_many_attached :processed_images

  validates :title, presence: true
  validates :images, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'] }
  validates :processed_images, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'] }
  validates :csvs, blob: { content_type: ['text/csv'] }
  validates :processed_csvs, blob: { content_type: ['text/csv'] }

  validate :json_validity

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  after_commit :parse_json, on: %i[create update]

  enum processing_status: { none: 0, successful: 1, pending: 2, ongoing: 3, error: 4, mixed: 5 }, _prefix: :processing
end
