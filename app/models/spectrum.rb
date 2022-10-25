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
#  processing_status :integer          default(0)
#  category          :integer          default("not_set"), not null
#  origin            :string           default(""), not null
#  owner             :string           default(""), not null
#
class Spectrum < RsdbRecord
  include PublicActivity::Model
  include Authorship
  include CustomValidations
  include ParseJson

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  tracked owner: proc { |controller, _model| controller.current_user }

  belongs_to :user
  has_many :spectrum_files, inverse_of: :spectrum, dependent: :destroy
  has_many :file_attachments, through: :spectrum_files
  accepts_nested_attributes_for :spectrum_files, reject_if: proc { |attributes| attributes['file'].blank? }

  has_many_attached :documents
  has_many_attached :images

  has_rich_text :description

  validates :title, presence: true
  validates :images, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'] }
  validate :json_validity

  after_commit :parse_json, on: %i[create update]

  enum category: { not_set: 0, ceramics: 1, pigments: 2, other: 3 }, _default: :not_set, _suffix: :category
end
