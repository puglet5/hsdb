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

  tracked owner: proc { |controller, _model| controller.current_user }

  belongs_to :user
  has_many_attached :csvs
  has_many_attached :files
  has_many_attached :processed_csvs
  has_many_attached :documents
  has_many_attached :images
  has_many_attached :processed_images

  validates :title, presence: true
  # validate :csv_type
  validate :image_type
  validate :json_validity

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  after_commit :parse_json, on: %i[create update]

  enum processing_status: { none: 0, successful: 1, pending: 2, ongoing: 3, error: 4, mixed: 5 }, _prefix: :processing

  private

  def csv_type
    csvs.each do |csv|
      unless csv.content_type.in?(%("text/csv"))
        errors.add(:csvs,
                   'need to be in a .csv file format')
      end
    end
  end

  def image_type
    images.each do |image|
      unless image.content_type.in?(%("image/jpeg image/png image/svg image/gif"))
        errors.add(:images,
                   'need to be in a specified file formats')
      end
    end
  end

  def json_validity
    errors.add(:metadata, 'is not a valid JSON object') unless JSON.is_json?(metadata)
  end

  def parse_json
    parsed_json = JSON.parse(metadata.to_s) if metadata
    # rubocop:disable Rails/SkipsModelValidations
    update_column(:metadata, parsed_json) if parsed_json
    # rubocop:enable Rails/SkipsModelValidations
  rescue JSON::ParserError
    errors.add(:metadata, 'might not be a valid JSON object')
  end
end
