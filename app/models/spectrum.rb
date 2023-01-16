# frozen_string_literal: true

# == Schema Information
#
# Table name: spectra
#
#  id         :bigint           not null, primary key
#  format     :integer          default("not_set"), not null
#  status     :integer          default("raw"), not null
#  category   :integer          default("not_set"), not null
#  sample_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  range      :integer          default("ir"), not null
#  metadata   :jsonb            not null
#
class Spectrum < RsdbRecord
  include Authorship
  include CustomValidations
  include ParseJson

  scope :by_status, ->(status) { where(status: status) }
  scope :by_format, ->(format) { where(format: format) }
  scope :by_range,  ->(range)  { where(range: range) }

  belongs_to :sample, inverse_of: :spectra, touch: true

  enum status: { raw: 0, successful: 1, pending: 2, ongoing: 3, error: 4, other: 5 }, _prefix: :processing, _default: :raw

  enum range: { not_set: 0, vis: 1, ir: 2, uv: 3, other: 4 }, _default: :ir

  enum format: { not_set: 0, csv: 1, imp: 2, spectable: 3, mon: 4, txt: 5, dat: 6, other: 7 }, _default: :not_set, _suffix: :format

  enum category: { not_set: 0 }, _default: :not_set, _suffix: :category

  has_one_attached :file
  has_one_attached :settings

  after_commit :parse_json, on: %i[create update]
end
